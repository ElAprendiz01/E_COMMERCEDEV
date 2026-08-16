from app.database.connection import get_connection

def cargar_reglas():

    conn = get_connection()

    cursor = conn.cursor()

    query = """
    SELECT
        R.ReglaID,
        R.NombreRegla,
        R.AccionDinamica,
        R.AccionPython,
        PK.PalabraClave
    FROM ReglasChatbot R
    LEFT JOIN PalabrasClaveRegla PK
        ON R.ReglaID = PK.ReglaID
    WHERE R.Activo = 1
      AND (PK.Activo = 1 OR PK.Activo IS NULL)
    """

    cursor.execute(query)

    reglas = {}

    for fila in cursor.fetchall():

        regla_id = fila.ReglaID

        if regla_id not in reglas:

            reglas[regla_id] = {
                "ReglaID": fila.ReglaID,
                "NombreRegla": fila.NombreRegla,
                "AccionDinamica": fila.AccionDinamica,
                "AccionPython": fila.AccionPython,
                "PalabrasClave": []
            }

        if fila.PalabraClave:
            reglas[regla_id]["PalabrasClave"].append(
                fila.PalabraClave.lower()
            )

    conn.close()

    return list(reglas.values())


def obtener_regla_por_id(regla_id: int):
    conn = get_connection()
    cursor = conn.cursor()

    query = """
    SELECT
        R.ReglaID,
        R.NombreRegla,
        R.AccionDinamica,
        R.AccionPython,
        PK.PalabraClave
    FROM ReglasChatbot R
    LEFT JOIN PalabrasClaveRegla PK
        ON R.ReglaID = PK.ReglaID
    WHERE R.Activo = 1
      AND R.ReglaID = ?
      AND (PK.Activo = 1 OR PK.Activo IS NULL)
    """

    cursor.execute(query, regla_id)
    filas = cursor.fetchall()
    conn.close()

    if not filas:
        return None

    regla = {
        "ReglaID": filas[0].ReglaID,
        "NombreRegla": filas[0].NombreRegla,
        "AccionDinamica": filas[0].AccionDinamica,
        "AccionPython": filas[0].AccionPython,
        "PalabrasClave": []
    }

    for fila in filas:
        if fila.PalabraClave:
            regla["PalabrasClave"].append(fila.PalabraClave.lower())

    return regla