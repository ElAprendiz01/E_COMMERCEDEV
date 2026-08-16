import os
from pathlib import Path

from dotenv import find_dotenv, load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent
DOTENV_PATH = find_dotenv(usecwd=True) or BASE_DIR / ".env"
load_dotenv(DOTENV_PATH, override=True)


def get_database_settings():
    driver = os.getenv("DB_DRIVER", "ODBC Driver 17 for SQL Server")
    server = os.getenv("DB_SERVER")
    database = os.getenv("DB_NAME")

    if not server or not database:
        raise EnvironmentError(
            "DB_SERVER and DB_NAME must be configured in the environment or .env file."
        )

    trusted_connection = os.getenv("DB_TRUSTED_CONNECTION", "yes").strip().lower() in (
        "yes",
        "true",
        "1",
    )
    username = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    timeout = int(os.getenv("DB_TIMEOUT", "30"))

    return {
        "driver": driver,
        "server": server,
        "database": database,
        "trusted_connection": trusted_connection,
        "username": username,
        "password": password,
        "timeout": timeout,
    }
