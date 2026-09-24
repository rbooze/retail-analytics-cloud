SQL Server
RetailAnalyticsDW
Fact.CustomerExperiment
        |
        | Python Extract
        v
Pandas DataFrame
        |
        | BigQuery Load API
        v
BigQuery retailanalytics-cloud.raw.fact_customer_experiment
        |
        v
dbt staging.stg_customer_experiment