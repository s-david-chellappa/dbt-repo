SELECT
    md5(cast(loyalty_tier_id as varchar)) AS loyalty_tier_key,
    loyalty_tier_id,
    tier_name,
    min_points,
    max_points,
    discount_rate,
    benefits_description,
    updated_at
FROM {{ ref('stg_landing__loyalty_tiers') }}
