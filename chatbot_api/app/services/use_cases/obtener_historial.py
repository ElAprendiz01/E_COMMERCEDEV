from app.repositories.conversation_repository import ConversationRepository
from app.core.models.conversation import ConversationRequest

class ObtenerHistorialUseCase:
    def __init__(self, repository: ConversationRepository):
        self.repository = repository

    def ejecutar(self, conversation_request: ConversationRequest):
        return self.repository.obtener_historial(conversation_request)
