{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}

WITH interactions AS (
    SELECT * FROM {{ ref('stg_landing__customer_interactions') }}
)

SELECT
    md5(cast(interaction_id as varchar)) AS interaction_key,
    interaction_id,
    customer_id,
    interaction_type,
    interaction_date,
    TO_NUMBER(TO_CHAR(interaction_date, 'YYYYMMDD')) AS interaction_date_key,
    channel_id,
    device_id,
    campaign_id,
    store_id,
    duration_seconds,
    ROUND(duration_seconds / 60.0, 2) AS duration_minutes,
    created_at,
    updated_at
FROM interactions

{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
