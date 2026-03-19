WITH warehouses AS (
    SELECT * FROM {{ ref('stg_landing__warehouses') }}
),

locations AS (
    SELECT * FROM {{ ref('stg_landing__locations') }}
)

SELECT
    {{ generate_surrogate_key(['w.warehouse_id']) }} AS warehouse_key,
    w.warehouse_id,
    w.warehouse_name,
    w.location_id,
    l.city AS warehouse_city,
    l.state_province AS warehouse_state,
    l.region AS warehouse_region,
    w.capacity_units,
    w.warehouse_type,
    w.is_active,
    w.updated_at
FROM warehouses w
LEFT JOIN locations l ON w.location_id = l.location_id
