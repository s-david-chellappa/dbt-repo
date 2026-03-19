SELECT
    employee_id,
    first_name,
    last_name,
    email,
    store_id,
    department,
    job_title,
    hire_date,
    termination_date,
    salary,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'employees') }}
