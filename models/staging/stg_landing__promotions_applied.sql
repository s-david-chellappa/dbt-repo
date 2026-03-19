SELECT
    promotion_applied_id,
    order_id,
    promotion_id,
    discount_amount,
    applied_date,
    created_at,
    updated_at
FROM {{ source('landing', 'promotions_applied') }}
