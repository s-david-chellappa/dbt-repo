SELECT
    currency_id,
    currency_code,
    currency_name,
    symbol,
    exchange_rate_to_usd,
    created_at,
    updated_at
FROM {{ source('landing', 'currencies') }}
