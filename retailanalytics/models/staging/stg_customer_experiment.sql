{{ config(
    materialized='view'
) }}

select
    ExperimentID,
    CustomerID,
    GroupName,
    PromotionID,
    StartDate,
    EndDate,
    Purchased,
    PurchaseDate,
    Revenue,
    Profit,
    Returned,
    ReturnAmount
from {{ source(
    'raw',
    'fact_customer_experiment'
    ) }}