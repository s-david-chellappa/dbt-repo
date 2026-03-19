SELECT
    {{ generate_surrogate_key(['brand_id']) }} AS brand_key,
    brand_id,
    brand_name,
    brand_owner,
    country_of_origin,
    is_active,
    updated_at
FROM {{ ref('stg_landing__brands') }}
