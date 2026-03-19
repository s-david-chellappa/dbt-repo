WITH promotions AS (
    SELECT * FROM {{ ref('stg_landing__promotions') }}
),

campaigns AS (
    SELECT * FROM {{ ref('stg_landing__campaigns') }}
)

SELECT
    {{ generate_surrogate_key(['p.promotion_id']) }} AS promotion_key,
    p.promotion_id,
    p.promotion_name,
    p.promotion_type,
    p.discount_percentage,
    p.discount_amount,
    p.start_date,
    p.end_date,
    DATEDIFF(DAY, p.start_date, p.end_date) AS duration_days,
    p.campaign_id,
    c.campaign_name,
    p.is_active,
    p.updated_at
FROM promotions p
LEFT JOIN campaigns c ON p.campaign_id = c.campaign_id
