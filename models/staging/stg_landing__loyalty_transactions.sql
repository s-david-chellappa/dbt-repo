SELECT
    loyalty_txn_id,
    customer_id,
    transaction_type,
    points,
    transaction_date,
    order_id,
    loyalty_tier_id,
    created_at,
    updated_at
FROM {{ source('landing', 'loyalty_transactions') }}
