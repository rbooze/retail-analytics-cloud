import sys
from pathlib import Path

import pandas as pd
import pyodbc

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from config.database_config import CONNECTION_STRING

def extract_customer_experiment():
    query = """
    SELECT
        ExperimentID,
        CustomerID,
        GroupName,
        PromotionID,
        StartDate,
        EndDate,
        Purchased,
        PurchaseDate,
        Revenue,
        Profit,
        Returned,
        ReturnAmount
    FROM Fact.CustomerExperiment
    """
    with pyodbc.connect(CONNECTION_STRING) as conn:
        df = pd.read_sql(
            query,
            conn
        )
    return df

if __name__ == "__main__":
    data = extract_customer_experiment()
    print(data.head())
    print(data.shape)