from app.database.connection import get_connection

try:
    conn = get_connection()

    cursor = conn.cursor()

    cursor.execute("SELECT DB_NAME()")

    resultado = cursor.fetchone()

    print("Base de datos conectada:", resultado[0])

    conn.close()

    print("Conexión exitosa")

except Exception as ex:
    print("Error:", ex)