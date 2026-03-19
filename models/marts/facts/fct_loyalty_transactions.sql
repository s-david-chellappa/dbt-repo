{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}

WITH loyalty AS (
    SELECT * FROM {{ ref('stg_landing__loyalty_transactions') }}
)

SELECT
    md5(cast(loyalty_txn_id as varchar)) AS loyalty_txn_key,
    loyalty_txn_id,
    customer_id,
    transaction_type,
    points,
    ABS(points) AS absolute_points,
    CASE WHEN points > 0 THEN points ELSE 0 END AS points_earned,
    CASE WHEN points < 0 THEN ABS(points) ELSE 0 END AS points_redeemed,
    transaction_date,
    TO_NUMBER(TO_CHAR(transaction_date, 'YYYYMMDD')) AS transaction_date_key,
    order_id,
    loyalty_tier_id,
    created_at,
    updated_at
FROM loyalty

{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
