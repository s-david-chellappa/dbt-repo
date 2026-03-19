SELECT
    loyalty_tier_id,
    tier_name,
    min_points,
    max_points,
    discount_rate,
    benefits_description,
    created_at,
    updated_at
FROM {{ source('landing', 'loyalty_tiers') }}
