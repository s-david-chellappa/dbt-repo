SELECT
    traffic_id,
    store_id,
    traffic_date,
    hour_of_day,
    visitor_count,
    device_id,
    channel_id,
    created_at,
    updated_at
FROM {{ source('landing', 'store_traffic') }}
