SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_amount,
    line_total,
    created_at,
    updated_at
FROM {{ source('landing', 'order_items') }}
