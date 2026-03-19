{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}

WITH traffic AS (
    SELECT * FROM {{ ref('stg_landing__store_traffic') }}
)

SELECT
    md5(cast(traffic_id as varchar)) AS traffic_key,
    traffic_id,
    store_id,
    traffic_date,
    TO_NUMBER(TO_CHAR(traffic_date, 'YYYYMMDD')) AS traffic_date_key,
    hour_of_day,
    visitor_count,
    device_id,
    channel_id,
    created_at,
    updated_at
FROM traffic

{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
