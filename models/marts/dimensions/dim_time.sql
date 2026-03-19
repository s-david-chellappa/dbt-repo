SELECT
    {{ generate_surrogate_key(['time_key']) }} AS time_dim_key,
    time_key,
    full_time,
    hour_24,
    hour_12,
    minute,
    am_pm,
    time_period,
    updated_at
FROM {{ ref('stg_landing__times') }}
