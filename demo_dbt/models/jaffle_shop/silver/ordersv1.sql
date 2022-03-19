{{ config(schema='JAFFLE_SILVER') }}

{{ 
    config(
    materialized = 'incremental',
    unique_key='order_id',
    on_schema_change='append_new_columns'
    )
}}

with orders as (

    select 
       order_id,
       count(distinct customer_id) as customer_id,
       date_trunc('day', order_date) as order_date,
       status       
        
    from {{ ref('stg_orders') }}

    {% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  where order_date >= (select max(order_date) from {{ this }})
    {% endif %}

    group by 1,3,4

),
intermdeiate as (

    select * from orders
    )
    select * from intermdeiate