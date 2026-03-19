SELECT
    brand_id,
    brand_name,
    brand_owner,
    country_of_origin,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'brands') }}
