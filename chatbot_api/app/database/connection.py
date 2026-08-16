import pyodbc
from app.core.config import get_database_settings

def get_connection():
    settings = get_database_settings()

    connection_parts = [
        f"DRIVER={{{settings['driver']}}}",
        f"SERVER={settings['server']}",
        f"DATABASE={settings['database']}",
        "TrustServerCertificate=YES",
    ]

    if settings["trusted_connection"]:
        connection_parts.append("Trusted_Connection=yes")
    else:
        if not settings["username"] or not settings["password"]:
            raise EnvironmentError(
                "DB_USER y DB_PASSWORD son requeridos si DB_TRUSTED_CONNECTION es false."
            )
        connection_parts.append(f"UID={settings['username']}")
        connection_parts.append(f"PWD={settings['password']}")

    connection_string = ";".join(connection_parts)

    # Pasar el timeout directamente como parámetro de pyodbc
    return pyodbc.connect(connection_string, timeout=int(settings.get("timeout", 30)))