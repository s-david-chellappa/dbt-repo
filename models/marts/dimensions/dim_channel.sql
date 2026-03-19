SELECT
    {{ generate_surrogate_key(['channel_id']) }} AS channel_key,
    channel_id,
    channel_name,
    channel_type,
    is_active,
    updated_at
FROM {{ ref('stg_landing__channels') }}
