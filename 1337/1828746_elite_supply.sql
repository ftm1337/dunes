WITH transfers as(
	SELECT
		value/1e18 as amt,
		value/74794315632011970000 as taxx,
		date_trunc('week', evt_block_time) as week
	FROM erc20_fantom.evt_Transfer
	WHERE
    	contract_address = '0xf43cc235e686d7bc513f53fbffb61f760c3a1882' --ELITE
    	and from <> '0x74bfb7e94bef5767f5f6ace2d0df73a224adb689'        --infintely extensible timelock
    	and to <> '0x74bfb7e94bef5767f5f6ace2d0df73a224adb689'          --infintely extensible timelock
    	and evt_block_number > 6707903        --creation
    	--and evt_block_number <> 6725779       --initial 133.7 liquidity at spooky
    	--and evt_block_number <> 6712556       --initial 133.7 liquidity at sushi
    	--and evt_block_number > 6762021        --exclude entire day 1 (this skews the chart)
),

volume as(
	SELECT
	    week,
		sum(amt) as vol7d,
		COUNT(amt) as txc,
		sum(taxx) as tax7d
	FROM transfers
	GROUP BY week
	ORDER BY week
)

SELECT
	weekd,
	vol7d,
	txc,
	tax7d,
	sum(vol7d) OVER(ORDER BY week) as cumm_vol,
	sum(tax7d) OVER(ORDER BY week) as cumm_tax,
	sum(txc) OVER(ORDER BY week) as cumm_txs,
	avg(vol7d/txc) OVER(ORDER BY week) as avg_vol_per_tx,
	avg(tax7d/txc) OVER(ORDER BY week) as avg_tax_per_tx,
FROM volume
