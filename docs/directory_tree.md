# Directory Tree

```text
retail-analytics-cloud/
├── .gitignore
├── LICENSE
├── README.md
├── bigquery/
├── credentials/
│   └── retailanalytics-dbt.json
├── dbt/
│   └── dbt_project.yml
├── docs/
│   ├── architecture.md
│   ├── directory_tree.md
│   └── sqlserver_to_bigquery_migration.md
├── logs/
│   └── dbt.log
├── powerbi/
├── python/
│   ├── requirements.txt
│   ├── config/
│   │   └── database_config.py
│   ├── extract/
│   │   └── extract_customer_experiment.py
│   ├── load/
│   │   └── load_to_bigquery.py
│   ├── logs/
│   │   └── dbt.log
│   └── pipeline/
│       └── run_customer_experiment_pipeline.py
├── retailanalytics/
│   ├── .gitignore
│   ├── README.md
│   ├── dbt_project.yml
│   ├── analyses/
│   │   └── .gitkeep
│   ├── logs/
│   │   └── dbt.log
│   ├── macros/
│   │   └── .gitkeep
│   ├── models/
│   │   └── staging/
│   │       ├── sources.yml
│   │       ├── staging.yml
│   │       └── stg_customer_experiment.sql
│   ├── seeds/
│   │   └── .gitkeep
│   ├── snapshots/
│   │   └── .gitkeep
│   └── tests/
│       └── .gitkeep
└── screenshots/
```

Generated directories such as `.git`, dbt `target`, and Python `__pycache__`
folders are intentionally omitted.