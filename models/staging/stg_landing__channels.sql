SELECT
    channel_id,
    channel_name,
    channel_type,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'channels') }}
