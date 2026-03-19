SELECT
    campaign_id,
    campaign_name,
    campaign_type,
    channel_id,
    budget,
    start_date,
    end_date,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'campaigns') }}
