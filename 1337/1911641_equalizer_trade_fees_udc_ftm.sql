 WITH
    V_USDC_WFTM_usdc AS (
        SELECT
            date_trunc('day', evt_block_time) as tspan
            , value/1e6 as USDC
        FROM erc20_fantom.evt_Transfer
        WHERE
            evt_block_number > 50760000 
            AND contract_address = lower('0x04068DA6C83AFCFA0e13ba15A6696662335D5B75')
            AND from = lower('0x7547d05dFf1DA6B4A2eBB3f0833aFE3C62ABD9a1')
            AND to = lower('0x4d472f1c1ff5adee203bae6b631bda5b3ff4ae00')
    ),
    V_USDC_WFTM_usdc_tspan as(
    	SELECT
    	    tspan
    		, sum(USDC) as USDC_per_tspan
    		, COUNT(USDC) as USDC_txc
    		--sum(taxx) as tax7d,
    		 
    	FROM V_USDC_WFTM_usdc
    	GROUP BY tspan
    	ORDER BY tspan
    ),
    V_USDC_WFTM_usdc_tspan_cumm AS (        
        SELECT
        	tspan,
        	USDC_per_tspan,
        	USDC_txc,
        	--tax7d,
        	sum(USDC_per_tspan) OVER(ORDER BY tspan) as USDC_tspan_cumm,
        	--sum(tax7d) OVER(ORDER BY tspan) as cumm_tax,
        	sum(USDC_txc) OVER(ORDER BY tspan) as USDC_txc_tspan_cumm
        FROM V_USDC_WFTM_usdc_tspan
        ORDER BY tspan DESC
    ),
    
    V_USDC_WFTM_wftm AS (
        SELECT
            date_trunc('day', evt_block_time) as tspan
            , value/1e18 as WFTM
        FROM erc20_fantom.evt_Transfer
        WHERE
            evt_block_number > 50760000 
            AND contract_address = lower('0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83')
            AND from = lower('0x7547d05dFf1DA6B4A2eBB3f0833aFE3C62ABD9a1')
            AND to = lower('0x4d472f1c1ff5adee203bae6b631bda5b3ff4ae00')
    ),
    
    V_USDC_WFTM_wftm_tspan as(
    	SELECT
    	    tspan
    		, sum(WFTM) as WFTM_per_tspan
    		, COUNT(WFTM) as WFTM_txc
    		--sum(taxx) as tax7d,
    		 
    	FROM V_USDC_WFTM_wftm
    	GROUP BY tspan
    	ORDER BY tspan
    ),
    V_USDC_WFTM_wftm_tspan_cumm AS (        
        SELECT
        	tspan,
        	WFTM_per_tspan,
        	WFTM_txc,
        	--tax7d,
        	sum(WFTM_per_tspan) OVER(ORDER BY tspan) as WFTM_tspan_cumm,
        	--sum(tax7d) OVER(ORDER BY tspan) as cumm_tax,
        	sum(WFTM_txc) OVER(ORDER BY tspan) as WFTM_txc_tspan_cumm
        FROM V_USDC_WFTM_wftm_tspan
        ORDER BY tspan DESC
    )
    --SELECT * from V_USDC_WFTM_usdc_tspan_cumm UNION all SELECT * from V_USDC_WFTM_wftm_tspan_cumm
SELECT
 * /*
    tspan
    , USDC_per_tspan
    , USDC_txc
    , USDC_tspan_cumm
    , USDC_txc_tspan_cumm
    , WFTM_per_tspan
    , WFTM_txc
    , WFTM_tspan_cumm
    , WFTM_txc_tspan_cumm
*/
FROM V_USDC_WFTM_usdc_tspan_cumm
FULL OUTER JOIN V_USDC_WFTM_wftm_tspan_cumm
ON V_USDC_WFTM_usdc_tspan_cumm.tspan = V_USDC_WFTM_wftm_tspan_cumm.tspan
ORDER BY V_USDC_WFTM_usdc_tspan_cumm.tspan DESC
