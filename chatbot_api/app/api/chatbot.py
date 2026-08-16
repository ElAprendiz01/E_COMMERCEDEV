import json
import traceback
import logging
from datetime import datetime
from decimal import Decimal
from fastapi import APIRouter, HTTPException, Body
from typing import Dict, Any, Optional

from app.repositories.conversation_repository import ConversationRepository
from app.repositories.reglas_repository import cargar_reglas
from app.services.chatbot_service import procesar_mensaje
from app.core.models.conversation import ConversationCreate, MessageIn, ConversationRequest

router = APIRouter(prefix="/api/chatbot", tags=["chatbot"])
repo_conversacion = ConversationRepository()
logger = logging.getLogger(__name__)


def sanitizar_json(obj):
    """
    Convierte Decimal, date, datetime y estructuras anidadas a tipos JSON-serializables.
    Devuelve estructuras equivalentes con strings/floats donde corresponda.
    """
    if isinstance(obj, Decimal):
        return float(obj)
    try:
        from datetime import date
        if isinstance(obj, date) and not isinstance(obj, datetime):
            return obj.isoformat()
    except Exception:
        pass
    if isinstance(obj, datetime):
        return obj.isoformat()
    if isinstance(obj, dict):
        return {k: sanitizar_json(v) for k, v in obj.items()}
    if isinstance(obj, list):
        return [sanitizar_json(item) for item in obj]
    return obj


@router.get("/rules")
def obtener_reglas():
    try:
        reglas = cargar_reglas()
        return reglas
    except Exception as ex:
        logger.exception("Error al cargar reglas")
        raise HTTPException(status_code=500, detail=f"Error al cargar reglas: {ex}")


@router.post("/chat")
def enviar_mensaje(request: Dict[str, Any] = Body(...)):
    """
    Endpoint principal:
      - Si recibe 'mensaje' llama al motor (procesar_mensaje) pasando conversation_id real.
      - Persiste la conversación y devuelve la respuesta del bot.
    """
    try:
        logger.info("POST /chat payload keys: %s", list(request.keys()))

        mensaje_text = request.get("mensaje")
        provided_conv_id = request.get("conversation_id") or request.get("conversationId")
        user_id = request.get("user_id") or request.get("userId") or "demo-user"

        # Rama: cliente envía messages completos (no legacy 'mensaje')
        if not mensaje_text:
            logger.info("No se recibió 'mensaje'; procesando payload.messages si existe.")
            payload_conversacion = {
                "conversation_id": provided_conv_id,
                "userId": user_id,
                "context": request.get("context"),
                "messages": request.get("messages", []),
            }
            try:
                res_repo = repo_conversacion.guardar_conversacion(payload_conversacion)
            except Exception as ex_repo:
                logger.exception("Error al guardar conversación (messages branch)")
                raise HTTPException(status_code=500, detail=f"Error al guardar conversación: {ex_repo}")
            conversation_id = res_repo.get("conversation_id") if isinstance(res_repo, dict) else res_repo
            return {"status": "ok", "conversation_id": conversation_id}

        # Llamada al motor/reglas pasando el conversation_id del usuario y el user_id
        try:
            respuesta_bot = procesar_mensaje(mensaje_text, conversacion_id=provided_conv_id or 1, user_id=user_id)
        except Exception as ex_proc:
            logger.exception("Error en procesar_mensaje")
            raise HTTPException(status_code=500, detail=f"Error interno en motor: {ex_proc}")

        # Asegurar que respuesta_bot sea dict para inspección
        if not isinstance(respuesta_bot, dict):
            logger.warning("procesar_mensaje devolvió tipo inesperado: %s", type(respuesta_bot))
            respuesta_bot = {"texto": str(respuesta_bot)}

        # Sanitizar profundamente la respuesta del motor
        respuesta_bot = sanitizar_json(respuesta_bot)

        bot_text = (
            respuesta_bot.get("texto")
            or respuesta_bot.get("text")
            or respuesta_bot.get("message")
            or respuesta_bot.get("body")
            or ""
        )

        productos = (
            respuesta_bot.get("productos")
            or respuesta_bot.get("items")
            or respuesta_bot.get("cards")
            or respuesta_bot.get("data")
            or []
        )
        productos = productos if isinstance(productos, list) else [productos] if productos else []

        productos_sanitizados = sanitizar_json(productos)

        try:
            metadata_json = json.dumps({"productos": productos_sanitizados}, default=str)
        except Exception:
            metadata_json = json.dumps({"productos": str(productos_sanitizados)})

        # Construir payload para la conversación persistida (asociando al user_id real del usuario)
        payload_conversacion = {
            "conversation_id": provided_conv_id,
            "userId": user_id,
            "context": {
                "language": "es",
                "session_variables": {
                    "last_intent": respuesta_bot.get("tipo") or respuesta_bot.get("intent") or "consulta",
                    "cart_id": None,
                    "order_id": None,
                },
            },
            "messages": [
                {
                    "role": "user",
                    "timestamp": datetime.now().isoformat(),
                    "intent": "usuario_pregunta",
                    "content": mensaje_text,
                    "metadata": None,
                },
                {
                    "role": "assistant",
                    "timestamp": datetime.now().isoformat(),
                    "intent": respuesta_bot.get("tipo") or respuesta_bot.get("intent") or "respuesta_bot",
                    "content": bot_text,
                    "metadata": metadata_json,
                },
            ],
        }

        try:
            res_repo = repo_conversacion.guardar_conversacion(payload_conversacion)
        except Exception as ex_repo:
            logger.exception("Error al guardar conversación (chat branch)")
            raise HTTPException(status_code=500, detail=f"Error al guardar conversación: {ex_repo}")

        conversation_id = res_repo.get("conversation_id") if isinstance(res_repo, dict) else res_repo

        respuesta_final = dict(respuesta_bot)
        respuesta_final["conversation_id"] = str(conversation_id)
        respuesta_final["conversationId"] = str(conversation_id)
        respuesta_final["productos"] = productos_sanitizados
        respuesta_final["texto"] = bot_text

        try:
            json.dumps(respuesta_final, default=str)
        except Exception:
            for k, v in list(respuesta_final.items()):
                try:
                    json.dumps({k: v}, default=str)
                except Exception:
                    respuesta_final[k] = str(v)

        return respuesta_final

    except HTTPException:
        raise
    except Exception as ex:
        logger.exception("Error en endpoint /chat")
        raise HTTPException(status_code=500, detail=f"Error interno al procesar mensaje: {str(ex)}")


@router.post("/conversations")
def create_conversation(payload: Dict[str, Any] = Body(...)):
    try:
        user_id = payload.get("userId") or payload.get("user_id") or "demo-user"
        messages = payload.get("messages", [])
        conv_payload = {"userId": user_id, "messages": messages}
        return repo_conversacion.guardar_conversacion(conv_payload)
    except Exception as ex:
        logger.exception("Error en create_conversation")
        raise HTTPException(status_code=500, detail=str(ex))


@router.post("/conversations/{conversation_id}/messages")
def post_message(conversation_id: int, message: MessageIn):
    try:
        return repo_conversacion.guardar_mensaje(conversation_id, message.dict())
    except Exception as ex:
        logger.exception("Error en post_message")
        raise HTTPException(status_code=500, detail=str(ex))


@router.get("/conversations/{conversation_id}/history")
def get_history(conversation_id: int):
    try:
        req = ConversationRequest(conversation_id=conversation_id)
        return repo_conversacion.obtener_historial(req)
    except Exception as ex:
        logger.exception("Error en get_history")
        raise HTTPException(status_code=500, detail=str(ex))


@router.get("/users/{user_id}/conversations")
def list_user_conversations(user_id: str, email: Optional[str] = None):
    try:
        return repo_conversacion.listar_conversaciones(user_id, email)
    except Exception as ex:
        logger.exception("Error en list_user_conversations")
        raise HTTPException(status_code=500, detail=str(ex))


@router.get("/health")
def health_check():
    return {"status": "ok", "service": "chatbot"}
