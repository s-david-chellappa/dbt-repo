{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set target_name = target.name | lower -%}

    {%- if target_name == 'development' -%}
        {# Personal schema — ignore all custom schemas #}
        {{ target.schema }}

    {%- else -%}
        {# Dev / Prod — respect dbt_project.yml schema definitions #}
        {%- if custom_schema_name is not none -%}
            {{ custom_schema_name | trim }}
        {%- else -%}
            {{ target.schema }}
        {%- endif -%}

    {%- endif -%}

{%- endmacro %}