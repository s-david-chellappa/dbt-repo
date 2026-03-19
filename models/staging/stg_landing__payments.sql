SELECT
    payment_id,
    order_id,
    payment_method_id,
    payment_date,
    amount,
    payment_status,
    currency_id,
    created_at,
    updated_at
FROM {{ source('landing', 'payments') }}
