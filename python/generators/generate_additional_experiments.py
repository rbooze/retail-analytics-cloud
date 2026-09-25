import pandas as pd
import numpy as np
from google.cloud import bigquery
from google.oauth2 import service_account
from pathlib import Path

PROJECT_ID = "retailanalytics-cloud"
PROJECT_ROOT = Path(__file__).resolve().parents[2]
CREDENTIALS_FILE = PROJECT_ROOT / "credentials" / "retailanalytics-dbt.json"

SOURCE_TABLE = (
    "retailanalytics-cloud.raw.fact_customer_experiment"
)

TARGET_TABLE = (
    "retailanalytics-cloud.raw.fact_customer_experiment"
)

credentials = service_account.Credentials.from_service_account_file(
    CREDENTIALS_FILE
)
client = bigquery.Client(
    credentials=credentials,
    project=credentials.project_id
)

# --------------------------------------------------
# Get existing customer population
# --------------------------------------------------
query = """
SELECT DISTINCT
    CustomerID
FROM `retailanalytics-cloud.raw.fact_customer_experiment`
WHERE 
    ExperimentID = 1
"""

customers = client.query(query).to_dataframe()

print(f"Customers loaded: {len(customers):,}")

# --------------------------------------------------
# Experiment generator
# --------------------------------------------------
def generate_experiment(
    experiment_id,
    start_date,
    end_date,
    control_rate,
    treatment_rate,
    avg_revenue,
    name
):

    df = customers.copy()

    # Random assignment
    df["GroupName"] = np.where(
        np.random.rand(len(df)) < 0.5,
        "Control",
        "Treatment"
    )

    purchase_probability = np.where(
        df["GroupName"] == "Treatment",
        treatment_rate,
        control_rate
    )

    df["Purchased"] = (
        np.random.rand(len(df))
        < purchase_probability
    )

    df["PurchaseDate"] = np.where(
        df["Purchased"],
        pd.to_datetime(start_date)
        +
        pd.to_timedelta(
            np.random.randint(
                0,
                90,
                len(df)
            ),
            unit="D"
        ),
        None
    )

    df["Revenue"] = np.where(
        df["Purchased"],
        np.random.normal(
            avg_revenue,
            avg_revenue * .25,
            len(df)
        ),
        0
    )

    df["Profit"] = np.where(
        df["Purchased"],
        df["Revenue"] * .45,
        0
    )

    returned_flag = (
    np.random.rand(len(df)) < .08
    )

    df["Returned"] = np.where(
        returned_flag,
        "true",
        "false"
    )

    df["ReturnAmount"] = np.where(
        returned_flag,
        (df["Revenue"] * .25).round(2).astype(str),
        "0.0"
    )

    df["ExperimentID"] = experiment_id
    df["PromotionID"] = np.nan
    df["StartDate"] = start_date
    df["EndDate"] = end_date

    return df[
        [
            "ExperimentID",
            "CustomerID",
            "GroupName",
            "PromotionID",
            "StartDate",
            "EndDate",
            "Purchased",
            "PurchaseDate",
            "Revenue",
            "Profit",
            "Returned",
            "ReturnAmount"
        ]
    ]

# --------------------------------------------------
# Create experiments
# --------------------------------------------------
free_shipping = generate_experiment(
    experiment_id=2,
    start_date="2026-04-01",
    end_date="2026-06-30",
    control_rate=.22,
    treatment_rate=.25,
    avg_revenue=95,
    name="Free Shipping Test"
)

loyalty_reward = generate_experiment(
    experiment_id=3,
    start_date="2026-07-01",
    end_date="2026-09-30",
    control_rate=.18,
    treatment_rate=.21,
    avg_revenue=110,
    name="Loyalty Reward Test"
)

new_data = pd.concat(
    [
        free_shipping,
        loyalty_reward
    ],
    ignore_index=True
)

print(new_data.head())
print(new_data.groupby("ExperimentID").size())

# --------------------------------------------------
# Append to BigQuery
# --------------------------------------------------
new_data["ExperimentID"] = new_data["ExperimentID"].astype("int64")
new_data["CustomerID"] = new_data["CustomerID"].astype("int64")
new_data["PromotionID"] = new_data["PromotionID"].astype("float64")
new_data["Revenue"] = new_data["Revenue"].astype("float64")
new_data["Profit"] = new_data["Profit"].astype("float64")

job = client.load_table_from_dataframe(
    new_data,
    TARGET_TABLE,
    job_config=bigquery.LoadJobConfig(
        write_disposition="WRITE_APPEND"
    )
)

job.result()

print("Experiments 2 and 3 loaded successfully.")