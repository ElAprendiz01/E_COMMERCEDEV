from pathlib import Path

from app.repositories.conversation_repository import ConversationRepository


def test_guardar_y_obtener_historial_persistido(tmp_path):
    storage_path = tmp_path / "conversations.json"
    repo = ConversationRepository(storage_path=str(storage_path))

    conversation = {
        "conversation_id": None,
        "user_id": "user-123",
        "messages": [
            {"role": "user", "content": "Hola", "timestamp": "2026-01-01T00:00:00"},
            {"role": "assistant", "content": "Hola, ¿en qué te ayudo?", "timestamp": "2026-01-01T00:00:01"},
        ],
    }

    result = repo.guardar_conversacion(conversation)

    assert result["status"] == "ok"
    assert result["id"]

    historial = repo.obtener_historial({"conversation_id": result["id"]})
    assert len(historial) == 2
    assert historial[0]["content"] == "Hola"
    assert historial[1]["content"] == "Hola, ¿en qué te ayudo?"

    conversaciones = repo.listar_conversaciones_usuario("user-123")
    assert len(conversaciones) == 1
    assert conversaciones[0]["userId"] == "user-123"
