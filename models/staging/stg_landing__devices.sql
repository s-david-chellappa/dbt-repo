SELECT
    device_id,
    device_type,
    device_os,
    browser,
    is_mobile,
    created_at,
    updated_at
FROM {{ source('landing', 'devices') }}
