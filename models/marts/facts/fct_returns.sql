{{
    config(
        materialized='incremental',
        unique_key='return_id',
        incremental_strategy='merge'
    )
}}

WITH returns AS (
    SELECT * FROM {{ ref('stg_landing__returns') }}
)

SELECT
    md5(cast(return_id as varchar)) AS return_key,
    return_id,
    order_id,
    order_item_id,
    return_reason_id,
    return_date,
    TO_NUMBER(TO_CHAR(return_date, 'YYYYMMDD')) AS return_date_key,
    CAST(refund_amount AS DECIMAL(12,2)) AS refund_amount,
    return_status,
    created_at,
    updated_at
FROM returns

{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
