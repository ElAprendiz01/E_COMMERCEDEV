from app.repositories.conversation_repository import ConversationRepository
from app.core.models.message import Message

class GuardarMensajeUseCase:
    def __init__(self, repository: ConversationRepository):
        self.repository = repository

    def ejecutar(self, conversation_id: str, message: Message):
        return self.repository.guardar_mensaje(conversation_id, message)
