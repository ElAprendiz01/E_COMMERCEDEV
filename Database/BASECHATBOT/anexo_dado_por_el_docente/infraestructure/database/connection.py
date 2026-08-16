import pyodbc

def get_connection():
    return pyodbc.connect(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost;"
        "DATABASE=DB_EcommerceAgent;"
        "UID=UserPython;"
        "PWD=12345678;"
    )