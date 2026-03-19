{{
    config(
        materialized='incremental',
        unique_key='supplier_order_id',
        incremental_strategy='merge'
    )
}}

WITH supplier_orders AS (
    SELECT * FROM {{ ref('stg_landing__supplier_orders') }}
)

SELECT
    md5(cast(supplier_order_id as varchar)) AS supplier_order_key,
    supplier_order_id,
    supplier_id,
    product_id,
    warehouse_id,
    order_date,
    TO_NUMBER(TO_CHAR(order_date, 'YYYYMMDD')) AS order_date_key,
    expected_delivery,
    actual_delivery,
    CASE WHEN actual_delivery IS NOT NULL THEN DATEDIFF(DAY, expected_delivery, actual_delivery) ELSE NULL END AS delivery_variance_days,
    CASE
        WHEN actual_delivery IS NULL THEN 'PENDING'
        WHEN actual_delivery <= expected_delivery THEN 'ON_TIME'
        ELSE 'LATE'
    END AS delivery_performance,
    quantity,
    CAST(unit_cost AS DECIMAL(10,2)) AS unit_cost,
    CAST(total_cost AS DECIMAL(12,2)) AS total_cost,
    order_status,
    created_at,
    updated_at
FROM supplier_orders

{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
