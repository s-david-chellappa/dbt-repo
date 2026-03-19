SELECT
    md5(cast(device_id as varchar)) AS device_key,
    device_id,
    device_type,
    device_os,
    browser,
    is_mobile,
    device_type || ' - ' || device_os AS device_label,
    updated_at
FROM {{ ref('stg_landing__devices') }}
