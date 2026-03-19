SELECT
    store_id,
    store_name,
    store_type,
    location_id,
    manager_employee_id,
    open_date,
    square_footage,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'stores') }}
