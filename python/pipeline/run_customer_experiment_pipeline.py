import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from extract.extract_customer_experiment import (extract_customer_experiment)
from load.load_to_bigquery import (load_dataframe_to_bigquery)

def main():
    df = extract_customer_experiment()
    load_dataframe_to_bigquery(df)

if __name__ == "__main__":
    main()