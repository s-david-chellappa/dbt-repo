WITH orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
),

order_items AS (
    SELECT * FROM {{ ref('fct_order_items') }}
),

dates AS (
    SELECT * FROM {{ ref('dim_date') }}
)

SELECT
    d.date_key,
    d.full_date,
    d.day_name,
    d.week_of_year,
    d.month_number,
    d.month_name,
    d.quarter_number,
    d.year_number,
    d.is_weekend,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COALESCE(SUM(CAST(o.total_amount AS DECIMAL(18,2))), 0) AS gross_sales,
    COALESCE(SUM(CAST(o.discount_amount AS DECIMAL(18,2))), 0) AS total_discounts,
    COALESCE(SUM(CAST(o.tax_amount AS DECIMAL(18,2))), 0) AS total_tax,
    COALESCE(SUM(CAST(o.shipping_amount AS DECIMAL(18,2))), 0) AS total_shipping,
    COALESCE(SUM(CAST(o.net_amount AS DECIMAL(18,2))), 0) AS net_sales,
    COALESCE(SUM(CAST(oi.line_total AS DECIMAL(18,2))), 0) AS total_item_revenue,
    COALESCE(SUM(CAST(oi.cost_amount AS DECIMAL(18,2))), 0) AS total_cost,
    COALESCE(SUM(CAST(oi.gross_profit AS DECIMAL(18,2))), 0) AS total_gross_profit,
    COALESCE(SUM(oi.quantity), 0) AS total_units_sold,
    CASE WHEN COUNT(DISTINCT o.order_id) > 0
        THEN ROUND(SUM(CAST(o.net_amount AS DECIMAL(18,2))) / COUNT(DISTINCT o.order_id), 2)
        ELSE 0
    END AS avg_order_value
FROM dates d
LEFT JOIN orders o ON d.date_key = o.order_date_key
    AND o.order_status NOT IN ('CANCELLED')
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    d.date_key, d.full_date, d.day_name, d.week_of_year,
    d.month_number, d.month_name, d.quarter_number, d.year_number, d.is_weekend
