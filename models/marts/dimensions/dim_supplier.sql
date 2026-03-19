SELECT
    {{ generate_surrogate_key(['supplier_id']) }} AS supplier_key,
    supplier_id,
    supplier_name,
    contact_name,
    contact_email,
    phone,
    country,
    city,
    rating,
    is_active,
    updated_at
FROM {{ ref('stg_landing__suppliers') }}
