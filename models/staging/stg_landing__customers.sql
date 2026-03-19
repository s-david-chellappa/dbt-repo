SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    date_of_birth,
    gender,
    loyalty_tier_id,
    registration_date,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'customers') }}
