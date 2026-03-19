SELECT
    payment_method_id,
    payment_method_name,
    payment_type,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'payment_methods') }}
