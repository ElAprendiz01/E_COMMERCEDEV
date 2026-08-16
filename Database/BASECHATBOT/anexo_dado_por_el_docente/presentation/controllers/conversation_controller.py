from fastapi import APIRouter
from domain.entities.conversation import Conversation,ConversationRequest
from domain.use_cases.procesar_conversacion import ProcesarConversacionUseCase
from domain.use_cases.obtener_historial import ObtenerHistorialUseCase
from infraestructure.repositories.conversation_repository import ConversationRepository

router = APIRouter()

@router.post("/chatbot/conversation")
def nueva_conversacion(conversation: Conversation):
    use_case = ProcesarConversacionUseCase(ConversationRepository())
    resultado = use_case.ejecutar(conversation)
    return resultado

@router.get("/chatbot/obtenerconversation")
def obtener_historial(conversation: ConversationRequest):
    use_case = ObtenerHistorialUseCase(ConversationRepository())
    resultado = use_case.ejecutar(conversation)
    return resultado