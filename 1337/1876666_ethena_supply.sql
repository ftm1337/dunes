WITH transfers as(
	SELECT
		value/1e18 as amt,
		date_trunc('hour', evt_block_time) as ts
	FROM erc20_bnb.evt_Transfer
	WHERE
      contract_address = '0xafbe3b8b0939a5538de32f7752a78e08c8492295' --eTHENA
      and evt_block_number > 24647388 --creation
      and from = '0x0000000000000000000000000000000000000000'
),

volume as(
	SELECT
		sum(amt) as mint_per_ts,
		COUNT(amt) as txc,
		ts FROM transfers
	GROUP BY ts
	ORDER BY ts
)

SELECT
	ts,
	mint_per_ts,
	txc,
	sum(mint_per_ts) OVER(ORDER BY ts) as total_mint,
	sum(txc) OVER(ORDER BY ts) as total_txs
FROM volume
ORDER BY ts DESC
