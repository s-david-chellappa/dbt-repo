SELECT
    md5(cast(payment_method_id as varchar)) AS payment_method_key,
    payment_method_id,
    payment_method_name,
    payment_type,
    is_active,
    updated_at
FROM {{ ref('stg_landing__payment_methods') }}
