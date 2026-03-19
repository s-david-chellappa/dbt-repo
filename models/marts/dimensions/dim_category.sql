WITH categories AS (
    SELECT * FROM {{ ref('stg_landing__categories') }}
)

SELECT
    {{ generate_surrogate_key(['c.category_id']) }} AS category_key,
    c.category_id,
    c.category_name,
    c.parent_category_id,
    p.category_name AS parent_category_name,
    c.category_level,
    c.is_active,
    c.updated_at
FROM categories c
LEFT JOIN categories p ON c.parent_category_id = p.category_id
