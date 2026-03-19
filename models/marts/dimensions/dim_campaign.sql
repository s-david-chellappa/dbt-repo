WITH campaigns AS (
    SELECT * FROM {{ ref('stg_landing__campaigns') }}
),

channels AS (
    SELECT * FROM {{ ref('stg_landing__channels') }}
)

SELECT
    {{ generate_surrogate_key(['ca.campaign_id']) }} AS campaign_key,
    ca.campaign_id,
    ca.campaign_name,
    ca.campaign_type,
    ca.channel_id,
    ch.channel_name,
    ca.budget,
    ca.start_date,
    ca.end_date,
    DATEDIFF(DAY, ca.start_date, ca.end_date) AS duration_days,
    ca.is_active,
    ca.updated_at
FROM campaigns ca
LEFT JOIN channels ch ON ca.channel_id = ch.channel_id
