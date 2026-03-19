WITH customers AS (
    SELECT * FROM {{ ref('stg_landing__customers') }}
),

loyalty_tiers AS (
    SELECT * FROM {{ ref('stg_landing__loyalty_tiers') }}
)

SELECT
    {{ generate_surrogate_key(['c.customer_id']) }} AS customer_key,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    c.phone,
    c.date_of_birth,
    DATEDIFF(YEAR, c.date_of_birth, CURRENT_DATE()) AS age,
    c.gender,
    c.loyalty_tier_id,
    lt.tier_name AS loyalty_tier_name,
    c.registration_date,
    c.is_active,
    c.updated_at
FROM customers c
LEFT JOIN loyalty_tiers lt ON c.loyalty_tier_id = lt.loyalty_tier_id
