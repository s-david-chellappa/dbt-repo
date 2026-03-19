{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}

WITH movements AS (
    SELECT * FROM {{ ref('stg_landing__inventory_movements') }}
)

SELECT
    md5(cast(movement_id as varchar)) AS movement_key,
    movement_id,
    product_id,
    warehouse_id,
    store_id,
    movement_type,
    quantity,
    CASE WHEN movement_type IN ('SHIPMENT', 'ADJUSTMENT') THEN quantity * -1 ELSE quantity END AS signed_quantity,
    movement_date,
    TO_NUMBER(TO_CHAR(movement_date, 'YYYYMMDD')) AS movement_date_key,
    reference_id,
    created_at,
    updated_at
FROM movements

{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
