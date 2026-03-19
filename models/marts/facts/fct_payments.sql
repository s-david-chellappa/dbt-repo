{{
    config(
        materialized='incremental',
        unique_key='payment_id',
        incremental_strategy='merge'
    )
}}

WITH payments AS (
    SELECT * FROM {{ ref('stg_landing__payments') }}
)

SELECT
    md5(cast(payment_id as varchar)) AS payment_key,
    payment_id,
    order_id,
    payment_method_id,
    payment_date,
    TO_NUMBER(TO_CHAR(payment_date, 'YYYYMMDD')) AS payment_date_key,
    CAST(amount AS DECIMAL(12,2)) AS amount,
    payment_status,
    currency_id,
    created_at,
    updated_at
FROM payments

{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
