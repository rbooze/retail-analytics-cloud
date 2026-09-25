{{ config(
    materialized='table'
) }}

WITH experiment_stats AS (
    SELECT
        ExperimentID,

        ControlCustomerCount,
        ControlPurchaserCount,

        TreatmentCustomerCount,
        TreatmentPurchaserCount,

        SAFE_DIVIDE(
            ControlPurchaserCount,
            ControlCustomerCount
        ) AS ControlPurchaseRate,

        SAFE_DIVIDE(
            TreatmentPurchaserCount,
            TreatmentCustomerCount
        ) AS TreatmentPurchaseRate
    FROM {{ ref('mart_experiment_results') }}
),

calculated AS (
    SELECT
        *,
        TreatmentPurchaseRate - ControlPurchaseRate AS AbsoluteLift,

        SAFE_DIVIDE(
            TreatmentPurchaseRate
                - ControlPurchaseRate,
            ControlPurchaseRate
        ) AS RelativeLift,

        SAFE_DIVIDE(
            (
                TreatmentPurchaseRate
                - ControlPurchaseRate
            ),

            SQRT(
                (
                    (
                        ControlPurchaseRate
                        *
                        (1-ControlPurchaseRate)
                    )
                    /
                    ControlCustomerCount
                )
                +
                (
                    (
                        TreatmentPurchaseRate
                        *
                        (1-TreatmentPurchaseRate)
                    )
                    /
                    TreatmentCustomerCount
                )
            )
        ) AS ZScore
    FROM experiment_stats
)

SELECT
    *,
    2 * (1 - ABS(ZScore)) AS ApproximatePValue,

    CASE
        WHEN ABS(ZScore) >= 1.96
        THEN TRUE
        ELSE FALSE
    END AS IsSignificant,

    CASE
        WHEN ABS(ZScore) >= 1.96
             AND AbsoluteLift > 0
        THEN 'Recommend Treatment'

        WHEN ABS(ZScore) >= 1.96
             AND AbsoluteLift < 0
        THEN 'Keep Control'

        ELSE 'No Significant Difference'
    END AS Recommendation

FROM calculated