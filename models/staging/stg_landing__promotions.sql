SELECT
    promotion_id,
    promotion_name,
    promotion_type,
    discount_percentage,
    discount_amount,
    start_date,
    end_date,
    campaign_id,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'promotions') }}
