{{
    config(
        materialized='incremental',
        unique_key='order_item_id',
        incremental_strategy='merge'
    )
}}

WITH order_items AS (
    SELECT * FROM {{ ref('stg_landing__order_items') }}
),

products AS (
    SELECT product_id, unit_cost FROM {{ ref('stg_landing__products') }}
)

SELECT
    md5(cast(order_item_id as varchar)) AS order_item_key,
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.quantity,
    CAST(oi.unit_price AS DECIMAL(10,2)) AS unit_price,
    CAST(oi.discount_amount AS DECIMAL(10,2)) AS discount_amount,
    CAST(oi.line_total AS DECIMAL(12,2)) AS line_total,
    CAST(COALESCE(p.unit_cost, 0) * oi.quantity AS DECIMAL(12,2)) AS cost_amount,
    CAST(oi.line_total - COALESCE(p.unit_cost, 0) * oi.quantity AS DECIMAL(12,2)) AS gross_profit,
    oi.created_at,
    oi.updated_at
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id

{% if is_incremental() %}
WHERE oi.updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
