SELECT
    category_id,
    category_name,
    parent_category_id,
    category_level,
    is_active,
    created_at,
    updated_at
FROM {{ source('landing', 'categories') }}
