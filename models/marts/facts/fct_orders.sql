{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge'
    )
}}

WITH orders AS (
    SELECT * FROM {{ ref('stg_landing__orders') }}
)

SELECT
    md5(cast(order_id as varchar)) AS order_key,
    o.order_id,
    o.customer_id,
    o.store_id,
    o.channel_id,
    o.order_date,
    TO_NUMBER(TO_CHAR(o.order_date, 'YYYYMMDD')) AS order_date_key,
    o.order_status,
    o.currency_id,
    CAST(o.total_amount AS DECIMAL(12,2)) AS total_amount,
    CAST(o.discount_amount AS DECIMAL(10,2)) AS discount_amount,
    CAST(o.tax_amount AS DECIMAL(10,2)) AS tax_amount,
    CAST(o.shipping_amount AS DECIMAL(10,2)) AS shipping_amount,
    CAST(o.total_amount - o.discount_amount + o.tax_amount + o.shipping_amount AS DECIMAL(12,2)) AS net_amount,
    o.payment_method_id,
    o.employee_id,
    o.created_at,
    o.updated_at
FROM orders o

{% if is_incremental() %}
WHERE o.updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
