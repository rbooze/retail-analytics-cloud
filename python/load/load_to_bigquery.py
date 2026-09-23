from pathlib import Path

from google.cloud import bigquery
from google.oauth2 import service_account


PROJECT_ROOT = Path(__file__).resolve().parents[2]
CREDENTIALS_FILE = PROJECT_ROOT / "credentials" / "retailanalytics-dbt.json"

def load_dataframe_to_bigquery(df):
    credentials = service_account.Credentials.from_service_account_file(
        CREDENTIALS_FILE
    )
    client = bigquery.Client(
        credentials=credentials,
        project=credentials.project_id
    )

    table_id = (
        "retailanalytics-cloud."
        "raw.fact_customer_experiment"
    )

    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_TRUNCATE"
    )

    job = client.load_table_from_dataframe(
        df,
        table_id,
        job_config=job_config
    )

    job.result()

    print(f"Loaded {len(df)} rows into {table_id}")