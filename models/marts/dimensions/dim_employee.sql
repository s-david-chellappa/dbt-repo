SELECT
    {{ generate_surrogate_key(['employee_id']) }} AS employee_key,
    employee_id,
    first_name,
    last_name,
    first_name || ' ' || last_name AS full_name,
    email,
    store_id,
    department,
    job_title,
    hire_date,
    termination_date,
    salary,
    is_active,
    updated_at
FROM {{ ref('stg_landing__employees') }}
