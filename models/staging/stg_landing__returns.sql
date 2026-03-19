SELECT
    return_id,
    order_id,
    order_item_id,
    return_reason_id,
    return_date,
    refund_amount,
    return_status,
    created_at,
    updated_at
FROM {{ source('landing', 'returns') }}
