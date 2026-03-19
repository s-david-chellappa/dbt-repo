WITH stores AS (
    SELECT * FROM {{ ref('stg_landing__stores') }}
),

locations AS (
    SELECT * FROM {{ ref('stg_landing__locations') }}
)

SELECT
    {{ generate_surrogate_key(['s.store_id']) }} AS store_key,
    s.store_id,
    s.store_name,
    s.store_type,
    s.location_id,
    l.city,
    l.state_province,
    l.country,
    l.region,
    l.postal_code,
    s.manager_employee_id,
    s.open_date,
    s.square_footage,
    s.is_active,
    s.updated_at
FROM stores s
LEFT JOIN locations l ON s.location_id = l.location_id
