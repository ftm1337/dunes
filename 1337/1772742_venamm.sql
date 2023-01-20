SELECT
    evt_block_time,
    evt_tx_hash,
    from AS people,
    to AS pool,
	tokenId
FROM
    erc721_fantom.evt_Transfer
WHERE
    contract_address = '0x8313f3551c4d3984ffbadfb42f780d0c8763ce94'
    AND (
        to    = '0xbda1d1fbcece78d424fd97b3de251ceb678c20df'  -- 1: 0.2 FTM
        OR to = '0x6b4a8b8e5e83a0e1631e5c01faf44fb371bd2956'  -- 2: 0.2 EQUAL
        OR to = '0x6fd26870883ee74e3cbbed4bca20ad5b4e207121'  -- 3: 0.447 EQUAL
    )
ORDER BY evt_block_time DESC
