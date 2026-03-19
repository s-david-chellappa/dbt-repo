SELECT
    return_reason_id,
    reason_code,
    reason_description,
    reason_category,
    created_at,
    updated_at
FROM {{ source('landing', 'return_reasons') }}
