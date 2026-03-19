WITH products AS (
    SELECT * FROM {{ ref('stg_landing__products') }}
),

categories AS (
    SELECT * FROM {{ ref('stg_landing__categories') }}
),

brands AS (
    SELECT * FROM {{ ref('stg_landing__brands') }}
)

SELECT
    {{ generate_surrogate_key(['p.product_id']) }} AS product_key,
    p.product_id,
    p.product_name,
    p.sku,
    p.category_id,
    c.category_name,
    c.parent_category_id,
    pc.category_name AS parent_category_name,
    p.brand_id,
    b.brand_name,
    b.country_of_origin AS brand_country,
    p.unit_price,
    p.unit_cost,
    CASE WHEN p.unit_price > 0 THEN ROUND((p.unit_price - p.unit_cost) / p.unit_price * 100, 2) ELSE 0 END AS margin_percentage,
    p.weight_kg,
    p.is_active,
    p.launch_date,
    p.updated_at
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN categories pc ON c.parent_category_id = pc.category_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
