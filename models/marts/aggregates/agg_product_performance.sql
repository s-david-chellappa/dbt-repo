WITH order_items AS (
    SELECT * FROM {{ ref('fct_order_items') }}
),

orders AS (
    SELECT order_id, order_status FROM {{ ref('fct_orders') }}
),

products AS (
    SELECT * FROM {{ ref('dim_product') }}
),

return_agg AS (
    SELECT
        oi2.product_id,
        COUNT(DISTINCT r.return_id) AS total_returns
    FROM {{ ref('fct_returns') }} r
    INNER JOIN {{ ref('fct_order_items') }} oi2 ON r.order_item_id = oi2.order_item_id
    GROUP BY oi2.product_id
)

SELECT
    p.product_id,
    p.product_name,
    p.sku,
    p.category_name,
    p.parent_category_name,
    p.brand_name,
    p.unit_price AS current_price,
    p.unit_cost AS current_cost,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COALESCE(SUM(oi.quantity), 0) AS total_units_sold,
    COALESCE(SUM(CAST(oi.line_total AS DECIMAL(18,2))), 0) AS total_revenue,
    COALESCE(SUM(CAST(oi.cost_amount AS DECIMAL(18,2))), 0) AS total_cost,
    COALESCE(SUM(CAST(oi.gross_profit AS DECIMAL(18,2))), 0) AS total_gross_profit,
    CASE WHEN COALESCE(SUM(CAST(oi.line_total AS DECIMAL(18,2))), 0) > 0
        THEN ROUND(SUM(CAST(oi.gross_profit AS DECIMAL(18,2))) / SUM(CAST(oi.line_total AS DECIMAL(18,2))) * 100, 2)
        ELSE 0
    END AS gross_margin_pct,
    COALESCE(SUM(CAST(oi.discount_amount AS DECIMAL(18,2))), 0) AS total_discounts,
    CASE WHEN COALESCE(SUM(oi.quantity), 0) > 0
        THEN ROUND(SUM(CAST(oi.line_total AS DECIMAL(18,2))) / SUM(oi.quantity), 2)
        ELSE 0
    END AS avg_selling_price,
    COALESCE(ra.total_returns, 0) AS total_returns,
    CASE WHEN COUNT(DISTINCT oi.order_id) > 0
        THEN ROUND(COALESCE(ra.total_returns, 0)::DECIMAL / COUNT(DISTINCT oi.order_id) * 100, 2)
        ELSE 0
    END AS return_rate_pct
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id
    AND o.order_status NOT IN ('CANCELLED')
LEFT JOIN return_agg ra ON p.product_id = ra.product_id
GROUP BY
    p.product_id, p.product_name, p.sku, p.category_name,
    p.parent_category_name, p.brand_name, p.unit_price, p.unit_cost,
    ra.total_returns
