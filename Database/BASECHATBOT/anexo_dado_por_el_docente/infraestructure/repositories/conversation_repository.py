import json
from infraestructure.database.connection import get_connection
from domain.entities.conversation import Conversation, ConversationRequest

class ConversationRepository:
    def guardar_conversacion(self, conversation: Conversation):
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute("EXEC sp_GuardarConversacion ?", conversation.json())
        conn.commit()

        cursor.close()
        conn.close()
        return {"status": "ok", "conversation_id": conversation.conversation_id}

    def obtener_historial(self, conversation: ConversationRequest):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("EXEC sp_ObtenerHistorialConversacion ?", conversation.conversation_id)
        columnas = [col[0] for col in cursor.description]
        resultados = []

        for row in cursor.fetchall():
            registro = dict(zip(columnas, row))

            metadata = registro.get("Metadata")
            if metadata and isinstance(metadata, str):
                try:
                    registro["Metadata"] = json.loads(metadata)
                except json.JSONDecodeError:
                    registro["Metadata"] = metadata

            resultados.append(registro)

        cursor.close()
        conn.close()
        return {"conversation_id": conversation.conversation_id, "messages": resultados}