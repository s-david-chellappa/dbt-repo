WITH orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
),

dates AS (
    SELECT * FROM {{ ref('dim_date') }}
),

returns AS (
    SELECT * FROM {{ ref('fct_returns') }}
)

SELECT
    d.year_number,
    d.month_number,
    d.month_name,
    d.year_number || '-' || LPAD(d.month_number, 2, '0') AS year_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COALESCE(SUM(CAST(o.total_amount AS DECIMAL(18,2))), 0) AS gross_revenue,
    COALESCE(SUM(CAST(o.discount_amount AS DECIMAL(18,2))), 0) AS total_discounts,
    COALESCE(SUM(CAST(o.net_amount AS DECIMAL(18,2))), 0) AS net_revenue,
    COUNT(DISTINCT r.return_id) AS total_returns,
    COALESCE(SUM(CAST(r.refund_amount AS DECIMAL(18,2))), 0) AS total_refunds,
    COALESCE(SUM(CAST(o.net_amount AS DECIMAL(18,2))), 0) - COALESCE(SUM(CAST(r.refund_amount AS DECIMAL(18,2))), 0) AS adjusted_revenue,
    CASE WHEN COUNT(DISTINCT o.order_id) > 0
        THEN ROUND(COUNT(DISTINCT r.return_id)::DECIMAL / COUNT(DISTINCT o.order_id) * 100, 2)
        ELSE 0
    END AS return_rate_pct,
    CASE WHEN COUNT(DISTINCT o.order_id) > 0
        THEN ROUND(SUM(CAST(o.net_amount AS DECIMAL(18,2))) / COUNT(DISTINCT o.order_id), 2)
        ELSE 0
    END AS avg_order_value
FROM dates d
LEFT JOIN orders o ON d.date_key = o.order_date_key
    AND o.order_status NOT IN ('CANCELLED')
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY
    d.year_number, d.month_number, d.month_name
