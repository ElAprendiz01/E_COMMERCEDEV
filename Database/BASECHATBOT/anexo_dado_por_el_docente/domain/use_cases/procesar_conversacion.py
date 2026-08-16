from infraestructure.repositories.conversation_repository import ConversationRepository
from domain.entities.conversation import Conversation

class ProcesarConversacionUseCase:
    def __init__(self, repository: ConversationRepository):
        self.repository = repository

    def ejecutar(self, conversation: Conversation):
        return self.repository.guardar_conversacion(conversation)
