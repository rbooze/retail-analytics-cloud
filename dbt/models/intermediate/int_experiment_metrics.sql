{{ config(
    materialized='table'
) }}

WITH experiment_data AS (
    SELECT *
    FROM {{ ref('stg_customer_experiment') }}
),

experiment_metadata AS (
    SELECT *
    FROM {{ ref('stg_experiment_metadata') }}
),

group_metrics AS (
    SELECT
        ed.ExperimentID,
        em.ExperimentName,
        em.Objective,
        ed.PromotionID,
        ed.GroupName,
        ed.StartDate,
        ed.EndDate,

        COUNT(ed.CustomerID) AS CustomerCount,

        SUM(
            CASE
                WHEN ed.Purchased THEN 1
                ELSE 0
            END
        ) AS PurchaserCount,

        SUM(ed.Revenue) AS TotalRevenue,
        SUM(ed.Profit) AS TotalProfit
    FROM experiment_data ed
    INNER JOIN experiment_metadata em
        ON ed.ExperimentID = em.ExperimentID
    GROUP BY
        ed.ExperimentID,
        em.ExperimentName,
        em.Objective,
        ed.PromotionID,
        ed.GroupName,
        ed.StartDate,
        ed.EndDate
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