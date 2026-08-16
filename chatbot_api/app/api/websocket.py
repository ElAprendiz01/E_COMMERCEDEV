import json
from fastapi import APIRouter, WebSocket, WebSocketDisconnect

from app.services.chatbot_service import procesar_mensaje

router = APIRouter()


@router.websocket("/ws/chat")
async def websocket_chat(websocket: WebSocket):
    await websocket.accept()

    try:
        while True:
            raw_data = await websocket.receive_text()
            try:
                data = json.loads(raw_data)
                if isinstance(data, dict):
                    mensaje = data.get("mensaje", "")
                    conversacion_id = int(data.get("conversacion_id", 1))
                else:
                    mensaje = raw_data
                    conversacion_id = 1
            except Exception:
                mensaje = raw_data
                conversacion_id = 1

            respuesta = procesar_mensaje(mensaje, conversacion_id)
            await websocket.send_text(json.dumps(respuesta, ensure_ascii=False))

    except WebSocketDisconnect:
        pass