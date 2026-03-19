SELECT
    {{ generate_surrogate_key(['location_id']) }} AS location_key,
    location_id,
    city,
    state_province,
    country,
    postal_code,
    region,
    latitude,
    longitude,
    timezone,
    updated_at
FROM {{ ref('stg_landing__locations') }}
