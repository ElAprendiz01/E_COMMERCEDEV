from inspect import signature

from app.services.actions_service import (
    cargar_saludos_db,
    buscar_producto_en_db,
)


ACCIONES = {
    "cargar_saludos_db": cargar_saludos_db,
    "buscar_producto_en_db": buscar_producto_en_db,
}


def ejecutar_accion(nombre_accion, mensaje=None):
    accion = ACCIONES.get(nombre_accion)
    if not accion:
        return "Acción no implementada."

    function_signature = signature(accion)
    try:
        if len(function_signature.parameters) == 0:
            return accion()
        return accion(mensaje)
    except Exception as ex:
        return f"Error al ejecutar acción '{nombre_accion}': {ex}"