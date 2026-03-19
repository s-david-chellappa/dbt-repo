SELECT
    supplier_order_id,
    supplier_id,
    product_id,
    warehouse_id,
    order_date,
    expected_delivery,
    actual_delivery,
    quantity,
    unit_cost,
    total_cost,
    order_status,
    created_at,
    updated_at
FROM {{ source('landing', 'supplier_orders') }}
