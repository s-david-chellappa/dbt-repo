SELECT
    order_id,
    customer_id,
    store_id,
    channel_id,
    order_date,
    order_status,
    currency_id,
    total_amount,
    discount_amount,
    tax_amount,
    shipping_amount,
    payment_method_id,
    employee_id,
    created_at,
    updated_at
FROM {{ source('landing', 'orders') }}
