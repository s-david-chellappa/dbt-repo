WITH orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
    WHERE order_status NOT IN ('CANCELLED')
),

customers AS (
    SELECT * FROM {{ ref('dim_customer') }}
),

return_agg AS (
    SELECT
        o2.customer_id,
        COUNT(DISTINCT r.return_id) AS total_returns,
        COALESCE(SUM(CAST(r.refund_amount AS DECIMAL(18,2))), 0) AS total_refunds
    FROM {{ ref('fct_returns') }} r
    INNER JOIN {{ ref('fct_orders') }} o2 ON r.order_id = o2.order_id
    GROUP BY o2.customer_id
),

loyalty_agg AS (
    SELECT
        customer_id,
        COALESCE(SUM(points_earned), 0) AS total_points_earned,
        COALESCE(SUM(points_redeemed), 0) AS total_points_redeemed
    FROM {{ ref('fct_loyalty_transactions') }}
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.full_name,
    c.email,
    c.loyalty_tier_name,
    c.registration_date,
    c.is_active,
    DATEDIFF(DAY, c.registration_date, CURRENT_DATE()) AS customer_tenure_days,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(DAY, MAX(o.order_date), CURRENT_DATE()) AS days_since_last_order,
    COALESCE(SUM(CAST(o.total_amount AS DECIMAL(18,2))), 0) AS lifetime_gross_spend,
    COALESCE(SUM(CAST(o.discount_amount AS DECIMAL(18,2))), 0) AS lifetime_discounts,
    COALESCE(SUM(CAST(o.net_amount AS DECIMAL(18,2))), 0) AS lifetime_net_spend,
    CASE WHEN COUNT(DISTINCT o.order_id) > 0
        THEN ROUND(SUM(CAST(o.net_amount AS DECIMAL(18,2))) / COUNT(DISTINCT o.order_id), 2)
        ELSE 0
    END AS avg_order_value,
    CASE WHEN COUNT(DISTINCT o.order_id) > 1
        THEN ROUND(
            DATEDIFF(DAY, MIN(o.order_date), MAX(o.order_date))::DECIMAL / (COUNT(DISTINCT o.order_id) - 1), 1
        )
        ELSE NULL
    END AS avg_days_between_orders,
    COALESCE(ra.total_returns, 0) AS total_returns,
    COALESCE(ra.total_refunds, 0) AS total_refunds,
    COALESCE(SUM(CAST(o.net_amount AS DECIMAL(18,2))), 0) - COALESCE(ra.total_refunds, 0) AS adjusted_lifetime_value,
    COALESCE(la.total_points_earned, 0) AS total_points_earned,
    COALESCE(la.total_points_redeemed, 0) AS total_points_redeemed,
    COALESCE(la.total_points_earned, 0) - COALESCE(la.total_points_redeemed, 0) AS points_balance
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN return_agg ra ON c.customer_id = ra.customer_id
LEFT JOIN loyalty_agg la ON c.customer_id = la.customer_id
GROUP BY
    c.customer_id, c.full_name, c.email, c.loyalty_tier_name,
    c.registration_date, c.is_active,
    ra.total_returns, ra.total_refunds,
    la.total_points_earned, la.total_points_redeemed
