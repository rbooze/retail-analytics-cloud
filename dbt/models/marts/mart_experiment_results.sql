{{ config(
    materialized='table'
) }}

WITH experiment_metrics AS (
    SELECT *
    FROM {{ ref('int_experiment_metrics') }}
),

control AS (
    SELECT
        ExperimentID,
        PromotionID,
        StartDate,
        EndDate,

        CustomerCount AS ControlCustomerCount,
        PurchaserCount AS ControlPurchaserCount,
        PurchaseRate AS ControlPurchaseRate,
        TotalRevenue AS ControlRevenue,
        TotalProfit AS ControlProfit
    FROM experiment_metrics
    WHERE 
        GroupName = 'Control'
),

treatment AS (
    SELECT
        ExperimentID,

        CustomerCount AS TreatmentCustomerCount,
        PurchaserCount AS TreatmentPurchaserCount,
        PurchaseRate AS TreatmentPurchaseRate,
        TotalRevenue AS TreatmentRevenue,
        TotalProfit AS TreatmentProfit
    FROM experiment_metrics
    WHERE 
        GroupName = 'Treatment'
)

SELECT
    c.ExperimentID,
    c.PromotionID,
    c.StartDate,
    c.EndDate,

    -- Control metrics
    c.ControlCustomerCount,
    c.ControlPurchaserCount,
    c.ControlPurchaseRate,
    c.ControlRevenue,
    c.ControlProfit,

    -- Treatment metrics
    t.TreatmentCustomerCount,
    t.TreatmentPurchaserCount,
    t.TreatmentPurchaseRate,
    t.TreatmentRevenue,
    t.TreatmentProfit,

    -- Experiment impact
    t.TreatmentPurchaseRate - c.ControlPurchaseRate AS AbsoluteLift,

    SAFE_DIVIDE(
        t.TreatmentPurchaseRate - c.ControlPurchaseRate,
        c.ControlPurchaseRate
    ) AS RelativeLift,

    (
        t.TreatmentPurchaseRate - c.ControlPurchaseRate
    ) * t.TreatmentCustomerCount
        AS IncrementalCustomers,

    t.TreatmentRevenue -
    (
        c.ControlRevenue /
        c.ControlCustomerCount
        * t.TreatmentCustomerCount
    ) AS IncrementalRevenue,

    t.TreatmentProfit -
    (
        c.ControlProfit /
        c.ControlCustomerCount
        * t.TreatmentCustomerCount
    ) AS IncrementalProfit
FROM control c
INNER JOIN treatment t
    ON c.ExperimentID = t.ExperimentID