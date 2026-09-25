{{ config(
    materialized='table'
) }}

SELECT
    ExperimentID,
    GroupName,

    COUNT(DISTINCT CustomerID) AS CustomerCount,

    COUNTIF(Purchased = TRUE) AS PurchaserCount,

    SAFE_DIVIDE(
        COUNTIF(Purchased = TRUE),
        COUNT(DISTINCT CustomerID)
    ) AS PurchaseRate,

    SUM(Revenue) AS TotalRevenue,

    SUM(Profit) AS TotalProfit,

    SAFE_DIVIDE(
        SUM(Profit),
        SUM(Revenue)
    ) AS ProfitMargin

FROM {{ ref('stg_customer_experiment') }}
GROUP BY
    ExperimentID,
    GroupName