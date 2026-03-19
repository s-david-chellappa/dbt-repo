SELECT
    movement_id,
    product_id,
    warehouse_id,
    store_id,
    movement_type,
    quantity,
    movement_date,
    reference_id,
    created_at,
    updated_at
FROM {{ source('landing', 'inventory_movements') }}
