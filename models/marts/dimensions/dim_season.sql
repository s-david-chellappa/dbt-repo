SELECT
    {{ generate_surrogate_key(['season_id']) }} AS season_key,
    season_id,
    season_name,
    start_month,
    end_month,
    year_number,
    season_name || ' ' || year_number AS season_label,
    updated_at
FROM {{ ref('stg_landing__seasons') }}
