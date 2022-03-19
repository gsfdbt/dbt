{% snapshot orders_snapshot %}

{{
    config(
      target_database='dbt',
      target_schema='JAFFLE_SILVER',
      unique_key='order_id',
      strategy= 'check',
      check_cols = 'all',
    )
}}

select * from {{ ref('stg_orders') }}

{% endsnapshot %}

