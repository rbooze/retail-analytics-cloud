import os

SQL_SERVER = r"localhost\SQLEXPRESS"

DATABASE = "RetailAnalyticsDW"

CONNECTION_STRING = (
    "Driver={ODBC Driver 17 for SQL Server};"
    f"Server={SQL_SERVER};"
    f"Database={DATABASE};"
    "Trusted_Connection=yes;"
)