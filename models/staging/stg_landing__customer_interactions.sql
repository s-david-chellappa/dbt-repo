SELECT
    interaction_id,
    customer_id,
    interaction_type,
    interaction_date,
    channel_id,
    device_id,
    campaign_id,
    store_id,
    duration_seconds,
    created_at,
    updated_at
FROM {{ source('landing', 'customer_interactions') }}
