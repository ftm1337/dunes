WITH 
    Deposits AS (
        SELECT
            block_time
            --,topic2,topic3,data
            , substring(topic2,27,64) AS user
            , bytea2numeric_v2(substring(topic3,3,64)) AS venft
            --, (substring(data,67,64)) as inc1
            --, (substring(data,3,64)) as inc2
            , bytea2numeric_v2(substring(data,3,64))/1e18 as inc
            , bytea2numeric_v2(substring(data,67,64))/1e18 as amt
        FROM bnb.logs
        WHERE
            contract_address = '0x39e3ca118ddfea3edc426b306b87f43da3251b4a'
            AND block_number >= 24677943
            AND topic1 = '0x7162984403f6c73c8639375d45a9187dfd04602231bd8e587c415718b5f7e5f9'
        ORDER BY 1 DESC
    )
    
    
    
    
    SELECT
        *
        --, SUM(bytea2numeric_v2(substring(data,3,64))/1e18) as inc
        --, SUM(bytea2numeric_v2(substring(data,67,64))/1e18) as amt
        , inc/amt as mint_price
        , (inc/amt - 1) * 100 as rebase_realized_pc
        , (inc/amt - 1) * 5200 as rebase_apr_pc
        , (power(inc/amt,52) - 1) * 100 as rebase_apy_pc
    FROM Deposits
