WITH sales AS (
    SELECT
        evt_block_time,
        evt_tx_hash,
        from,
        to,
    	tokenId,
    	date_trunc('day', evt_block_time) as dates
    FROM
        erc721_fantom.evt_Transfer
    WHERE
        contract_address = '0x8313f3551c4d3984ffbadfb42f780d0c8763ce94'
        AND (
            to    = '0xbda1d1fbcece78d424fd97b3de251ceb678c20df'
            OR to = '0x6b4a8b8e5e83a0e1631e5c01faf44fb371bd2956'
            OR to = '0x6fd26870883ee74e3cbbed4bca20ad5b4e207121'
        )
),

volumes AS(
    SELECT
        dates,
        COUNT(evt_tx_hash) as daily_sales
    FROM
        sales
	GROUP BY dates
	ORDER BY dates DESC
)

SELECT
    dates,
    daily_sales,
    SUM(daily_sales) OVER(ORDER BY dates) AS total_sales
FROM
    volumes
    
    
