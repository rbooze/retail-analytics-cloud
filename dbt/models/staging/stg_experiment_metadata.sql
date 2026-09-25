SELECT
    ExperimentID,
    ExperimentName,
    Objective,
    StartDate,
    EndDate,
    ControlGroup,
    TreatmentGroup
FROM {{ source('raw', 'experiment_metadata') }}