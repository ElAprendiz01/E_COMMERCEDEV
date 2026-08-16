from typing import Union, Dict, Any
from app.database.connection import get_connection
from app.repositories.products_repository import buscar_producto


def procesar_mensaje_db(mensaje: str, conversacion_id: Union[int, str] = 1, user_id: str = "1") -> Dict[str, Any]:
    try:
        conn = get_connection()
        cursor = conn.cursor()

        conv_id_str = str(conversacion_id) if conversacion_id is not None else "1"
        user_id_str = str(user_id) if user_id is not None else "1"

        try:
            cursor.execute(
                """
                SET NOCOUNT ON;
                DECLARE @o_TextoRespuesta NVARCHAR(MAX);
                DECLARE @o_ReglaActivadaID INT;
                EXEC dbo.SP_ProcesarMensajeChatbot ?, ?, @o_TextoRespuesta OUTPUT, @o_ReglaActivadaID OUTPUT, ?;
                SELECT @o_TextoRespuesta AS TextoRespuesta, @o_ReglaActivadaID AS ReglaActivadaID;
                """,
                conv_id_str,
                mensaje,
                user_id_str,
            )
        except Exception as ex_sp:
            if "8144" in str(ex_sp) or "too many arguments" in str(ex_sp).lower():
                cursor.execute(
                    """
                    SET NOCOUNT ON;
                    DECLARE @o_TextoRespuesta NVARCHAR(MAX);
                    DECLARE @o_ReglaActivadaID INT;
                    EXEC dbo.SP_ProcesarMensajeChatbot ?, ?, @o_TextoRespuesta OUTPUT, @o_ReglaActivadaID OUTPUT;
                    SELECT @o_TextoRespuesta AS TextoRespuesta, @o_ReglaActivadaID AS ReglaActivadaID;
                    """,
                    conv_id_str,
                    mensaje,
                )
            else:
                raise ex_sp

        while cursor.description is None:
            if not cursor.nextset():
                break

        resultado = cursor.fetchone()

        conn.commit()
        cursor.close()
        conn.close()

        if resultado:
            regla_id = resultado.ReglaActivadaID
            texto_respuesta = resultado.TextoRespuesta or "No se obtuvo respuesta del agente."

            print(f"[Engine] Regla Activada: {regla_id} | Respuesta: {texto_respuesta[:50]}...")

            # Regla 2 = Búsqueda de productos (adjunta la lista de productos para cards en Frontend)
            if regla_id == 2:
                productos = buscar_producto(mensaje)
                return {
                    "tipo": "productos",
                    "texto": texto_respuesta,
                    "regla_id": 2,
                    "productos": productos,
                }

            return {
                "tipo": "texto",
                "texto": texto_respuesta,
                "regla_id": regla_id,
            }

        return {
            "tipo": "texto",
            "texto": "No se obtuvo respuesta del motor de reglas.",
            "regla_id": None,
        }

    except Exception as ex:
        print(f"[Engine Error] Exception: {ex}")
        return {
            "tipo": "texto",
            "texto": f"Error al procesar mensaje en la base de datos: {ex}",
            "regla_id": None,
        }


def buscar_producto_en_db(mensaje=None):
    try:
        if not mensaje:
            return {
                "mensaje": "Necesito un texto para buscar productos.",
                "productos": [],
            }

        productos = buscar_producto(mensaje)

        if not productos:
            return {
                "mensaje": f"No se encontró ningún producto con '{mensaje}'.",
                "productos": [],
            }

        return {
            "mensaje": f"Se encontraron {len(productos)} producto(s).",
            "productos": productos,
        }

    except Exception as ex:
        return {
            "mensaje": f"Error al buscar producto en la base de datos: {ex}",
            "productos": [],
        }