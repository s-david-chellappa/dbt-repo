{% macro generate_surrogate_key(field_list) -%}
    MD5(CONCAT_WS('|',
        {%- for field in field_list %}
        COALESCE(CAST({{ field }} AS VARCHAR), '_dbt_utils_surrogate_key_null_')
        {%- if not loop.last -%} , {%- endif -%}
        {%- endfor %}
    ))
{%- endmacro %}
