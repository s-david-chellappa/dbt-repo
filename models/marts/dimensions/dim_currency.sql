SELECT
    md5(cast(currency_id as varchar)) AS currency_key,
    currency_id,
    currency_code,
    currency_name,
    symbol,
    exchange_rate_to_usd,
    updated_at
FROM {{ ref('stg_landing__currencies') }}
