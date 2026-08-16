from app.services.actions_service import procesar_mensaje_db


def procesar_mensaje(mensaje: str, conversacion_id: int = 1, user_id: str = "1"):
    return procesar_mensaje_db(mensaje, conversacion_id, user_id)
