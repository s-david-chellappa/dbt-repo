SELECT
    product_id,
    product_name,
    sku,
    category_id,
    brand_id,
    unit_price,
    unit_cost,
    weight_kg,
    is_active,
    launch_date,
    created_at,
    updated_at
FROM {{ source('landing', 'products') }}
