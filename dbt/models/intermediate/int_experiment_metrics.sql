{{ config(
    materialized='table'
) }}

WITH experiment_data AS (
    SELECT *
    FROM {{ ref('stg_customer_experiment') }}
),

group_metrics AS (
    SELECT
        ExperimentID,
        PromotionID,
        GroupName,
        StartDate,
        EndDate,

        COUNT(CustomerID) AS CustomerCount,

        SUM(
            CASE
                WHEN Purchased THEN 1
                ELSE 0
            END
        ) AS PurchaserCount,

        SUM(Revenue) AS TotalRevenue,
        SUM(Profit) AS TotalProfit
    FROM experiment_data
    GROUP BY
        ExperimentID,
        PromotionID,
        GroupName,
        StartDate,
        EndDate
)

-- Separated into a final SELECT because of how SQL handles column aliases (CustomerCount and PurchaserCount) in the same SELECT statement.
SELECT
    *,

    SAFE_DIVIDE(
        PurchaserCount,
        CustomerCount
    ) AS PurchaseRate,

    SAFE_DIVIDE(
        TotalProfit,
        TotalRevenue
    ) AS ProfitMargin
FROM group_metrics