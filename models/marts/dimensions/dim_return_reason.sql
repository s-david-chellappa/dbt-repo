SELECT
    md5(cast(return_reason_id as varchar)) AS return_reason_key,
    return_reason_id,
    reason_code,
    reason_description,
    reason_category,
    updated_at
FROM {{ ref('stg_landing__return_reasons') }}
