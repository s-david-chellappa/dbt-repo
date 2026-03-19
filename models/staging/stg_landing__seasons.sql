SELECT
    season_id,
    season_name,
    start_month,
    end_month,
    year_number,
    created_at,
    updated_at
FROM {{ source('landing', 'seasons') }}
