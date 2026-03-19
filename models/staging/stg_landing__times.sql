SELECT
    time_key,
    full_time,
    hour_24,
    hour_12,
    minute,
    am_pm,
    time_period,
    created_at,
    updated_at
FROM {{ source('landing', 'times') }}
