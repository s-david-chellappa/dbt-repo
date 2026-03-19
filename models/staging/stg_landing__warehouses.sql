SELECT
    warehouse_id,
    warehouse_name,
    location_id,
    capacity_units,
    warehouse_type,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'warehouses') }}
