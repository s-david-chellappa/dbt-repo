SELECT
    location_id,
    city,
    state_province,
    country,
    postal_code,
    region,
    latitude,
    longitude,
    timezone,
    created_at,
    updated_at
FROM {{ source('landing', 'locations') }}
