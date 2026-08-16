from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel

from app.core.models.conversation import (
    Conversation,
    ConversationRequest,
    CreateConversationRequest,
)
from app.services.use_cases.procesar_conversacion import ProcesarConversacionUseCase
from app.services.use_cases.obtener_historial import ObtenerHistorialUseCase
from app.repositories.conversation_repository import ConversationRepository
from app.database.connection import get_connection

router = APIRouter(prefix="/api/chatbot", tags=["conversations"])


# ======================================================
# MODELOS PARA EL FRONTEND
# ======================================================

class CreateConversationRequest(BaseModel):
    userId: str
    title: str | None = None


class SaveMessageRequest(BaseModel):
    userId: str | None = "demo-user"
    role: str
    content: str
    timestamp: str
    isBot: bool = False
    tipo: str | None = None
    productos: list | None = None


# ======================================================
# CREAR CONVERSACIÓN
# ======================================================

@router.post("/conversations")
def nueva_conversacion(request: CreateConversationRequest):
    try:

        conversation = {
            "conversation_id": None,
            "user_id": request.userId,
            "messages": [],
            "context": {
                "language": "es",
                "session_variables": {}
            }
        }

        use_case = ProcesarConversacionUseCase(
            ConversationRepository()
        )

        return use_case.ejecutar(conversation)

    except Exception as ex:
        raise HTTPException(
            status_code=500,
            detail=f"Error al crear conversación: {ex}"
        )


# ======================================================
# OBTENER HISTORIAL (ENDPOINT ANTIGUO)
# ======================================================

@router.get("/obtenerconversation")
def obtener_historial_conversacion(conversation_id: str):

    try:

        use_case = ObtenerHistorialUseCase(
            ConversationRepository()
        )

        solicitud = ConversationRequest(
            conversation_id=conversation_id
        )

        return use_case.ejecutar(solicitud)

    except Exception as ex:

        raise HTTPException(
            status_code=500,
            detail=f"Error al obtener historial: {ex}"
        )


# ======================================================
# GUARDAR MENSAJE
# (Lo conectaremos al SP después)
# ======================================================

@router.post("/conversations/{conversation_id}/messages")
def guardar_mensaje(
    conversation_id: str,
    request: SaveMessageRequest
):
    try:
        conversation = {
            "conversation_id": conversation_id,
            "user_id": request.userId or "demo-user",
            "messages": [
                {
                    "role": request.role,
                    "content": request.content,
                    "timestamp": request.timestamp,
                    "appliedRuleId": None
                }
            ]
        }

        repo = ConversationRepository()
        return repo.guardar_conversacion(conversation)

    except Exception as ex:
        raise HTTPException(status_code=500, detail=f"Error al guardar mensaje: {ex}")


# ======================================================
# OBTENER MENSAJES
# ======================================================

@router.get("/conversations/{conversation_id}/messages")
def obtener_conversacion_mensajes(
    conversation_id: str
):

    try:

        use_case = ObtenerHistorialUseCase(
            ConversationRepository()
        )

        solicitud = ConversationRequest(
            conversation_id=conversation_id
        )

        return use_case.ejecutar(solicitud)

    except Exception as ex:

        raise HTTPException(
            status_code=500,
            detail=f"Error al obtener mensajes: {ex}"
        )


# ======================================================
# LISTAR CONVERSACIONES
# ======================================================

@router.get("/conversations")
def obtener_conversaciones_usuario(
    userId: str = Query("demo-user")
):

    try:

        repo = ConversationRepository()
        conversaciones = repo.listar_conversaciones_usuario(userId)

        return conversaciones

    except Exception as ex:

        raise HTTPException(
            status_code=500,
            detail=f"Error al obtener conversaciones: {ex}"
        )