with solidlyeth_deposits AS (
        SELECT 
        value/ 1e18 AS amount, 
        from as from_address,
        evt_tx_hash,
        contract_address
         --   sum(tr.value/1e18) as amount,
          --  tr.evt_tx_hash
        FROM erc20_fantom.evt_Transfer tr
        WHERE
            evt_block_number > 40570477

            and --()
                --contract_address = lower('0xDA0053F0bEfCbcaC208A3f867BB243716734D809') --oxSOLID contract
                --or contract_address = lower('0x41adAc6C1Ff52C5e27568f27998d747F7b69795B') -- SOLIDsec contract
                contract_address = lower('0x888EF71766ca594DED1F0FA3AE64eD2941740A20') -- SOLID contract )
            
            
             and to = lower('0x12e569ce813d28720894c2a0ffe6bec3ccd959b2')  --solidlyETH burn
),

depositors AS (
SELECT
    from AS depositor,
    evt_tx_hash
FROM erc20_fantom.evt_Transfer tr
WHERE 
    evt_block_number > 40570477
    AND evt_tx_hash IN (SELECT evt_tx_hash FROM solidlyeth_deposits)

),


base AS (
SELECT 
    d.depositor,
    c.evt_tx_hash,
    c.amount
FROM solidlyeth_deposits AS c
LEFT JOIN depositors AS d
    ON c.evt_tx_hash = d.evt_tx_hash
),

solidly_perc AS (
SELECT *,
    total_solidly_deposit / SUM(total_solidly_deposit) OVER () * 100 AS deposit_perc
FROM (
    SELECT
        depositor,
        SUM(amount) AS total_solidly_deposit
    FROM base
    GROUP BY depositor
    ) AS t
)





SELECT
    depositor,
    total_solidly_deposit,
    deposit_perc
FROM solidly_perc
ORDER BY deposit_perc DESC
LIMIT {{top_n}}
