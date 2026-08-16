from infraestructure.repositories.conversation_repository import ConversationRepository

class ObtenerHistorialUseCase:
    def __init__(self, repository: ConversationRepository):
        self.repository = repository

    def ejecutar(self, conversation_id: str):
        return self.repository.obtener_historial(conversation_id)
