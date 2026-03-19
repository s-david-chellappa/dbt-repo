SELECT
    supplier_id,
    supplier_name,
    contact_name,
    contact_email,
    phone,
    country,
    city,
    rating,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'suppliers') }}
