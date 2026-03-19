WITH orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
),

stores AS (
    SELECT * FROM {{ ref('dim_store') }}
),

traffic AS (
    SELECT
        store_id,
        SUM(visitor_count) AS total_visitors
    FROM {{ ref('fct_store_traffic') }}
    GROUP BY store_id
),

return_agg AS (
    SELECT
        o2.store_id,
        COUNT(DISTINCT r.return_id) AS total_returns,
        COALESCE(SUM(CAST(r.refund_amount AS DECIMAL(18,2))), 0) AS total_refunds
    FROM {{ ref('fct_returns') }} r
    INNER JOIN {{ ref('fct_orders') }} o2 ON r.order_id = o2.order_id
    GROUP BY o2.store_id
)

SELECT
    s.store_id,
    s.store_name,
    s.store_type,
    s.city,
    s.state_province,
    s.region,
    s.square_footage,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COALESCE(SUM(CAST(o.total_amount AS DECIMAL(18,2))), 0) AS gross_sales,
    COALESCE(SUM(CAST(o.net_amount AS DECIMAL(18,2))), 0) AS net_sales,
    CASE WHEN s.square_footage > 0
        THEN ROUND(COALESCE(SUM(CAST(o.net_amount AS DECIMAL(18,2))), 0) / s.square_footage, 2)
        ELSE 0
    END AS revenue_per_sqft,
    COALESCE(t.total_visitors, 0) AS total_visitors,
    CASE WHEN COALESCE(t.total_visitors, 0) > 0
        THEN ROUND(COUNT(DISTINCT o.order_id)::DECIMAL / t.total_visitors * 100, 2)
        ELSE 0
    END AS conversion_rate_pct,
    COALESCE(ra.total_returns, 0) AS total_returns,
    COALESCE(ra.total_refunds, 0) AS total_refunds
FROM stores s
LEFT JOIN orders o ON s.store_id = o.store_id
    AND o.order_status NOT IN ('CANCELLED')
LEFT JOIN traffic t ON s.store_id = t.store_id
LEFT JOIN return_agg ra ON s.store_id = ra.store_id
GROUP BY
    s.store_id, s.store_name, s.store_type, s.city,
    s.state_province, s.region, s.square_footage,
    t.total_visitors, ra.total_returns, ra.total_refunds
