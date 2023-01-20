with
  et_raw as (
    select
      block_time as et_time,
      bytea2numeric(substring(data,1,32))/1e18 as et_d_0_in,
      bytea2numeric(substring(data,33,32))/1e18 as et_d_1_in,
      bytea2numeric(substring(data,65,32))/1e18 as et_d_0_out,
      bytea2numeric(substring(data,97,32))/1e18 as et_d_1_out
      --data as et_data,
      --tx_hash
    from
      bsc.logs
    where
      topic1 = '\xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822'
      and contract_address = '\x9798a3835c8c87bd92803c3a248ae0042fbe4c6c'
  ),

All_Sells as (
    select
        et_time
        ,(et_d_1_out / et_d_0_in) as price --pr_sell_raw
        ,et_d_0_in as vol_0
        ,et_d_1_out as vol_1
    FROM et_raw
    where
        et_d_0_in <> 0
),


All_Buys as (
    select
        et_time
        ,(et_d_1_in / et_d_0_out) as price --pr_sell_raw
        ,et_d_0_out as vol_0
        ,et_d_1_in as vol_1
    FROM et_raw
    where
        et_d_0_out <> 0
),

All_Trades as (
    select * from All_Sells
    UNION ALL
    select * from All_Buys
),

Avg_Price as (
    select
        date_trunc('minute', et_time) as tspan,
        sum(vol_0) as vol_0,
        avg(price) as avg_price,
        sum(vol_1) as vol_1
    from All_Trades
    GROUP by tspan
    order by tspan DESC
),

Price_of_BNB as (
    SELECT
        date_trunc('minute', minute) as tspan
        ,price as price_of_bnb
        from prices."usd" 
    where symbol = 'WBNB' and minute>'2023-01-13 00:00'
    ORDER by tspan DESC
),

Result as (
    select * from Avg_Price
    INNER JOIN
    Price_of_BNB
    ON Avg_Price.tspan = Price_of_BNB.tspan
)

select
    vol_1 * price_of_bnb as usd_vol1
    ,avg_price*price_of_bnb as usd_price
    ,*
from Result
    --select * from All_Trades
