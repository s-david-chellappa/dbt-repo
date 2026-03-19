{{
    config(
        materialized='incremental',
        unique_key='promotion_applied_id',
        incremental_strategy='merge'
    )
}}

WITH promo_applied AS (
    SELECT * FROM {{ ref('stg_landing__promotions_applied') }}
)

SELECT
    md5(cast(promotion_applied_id as varchar)) AS promotion_applied_key,
    promotion_applied_id,
    order_id,
    promotion_id,
    CAST(discount_amount AS DECIMAL(10,2)) AS discount_amount,
    applied_date,
    TO_NUMBER(TO_CHAR(applied_date, 'YYYYMMDD')) AS applied_date_key,
    created_at,
    updated_at
FROM promo_applied

{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
