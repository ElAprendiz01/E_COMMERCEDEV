from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware  # 1. Importar el middleware

from app.api.chatbot import router as chatbot_router
from app.api.websocket import router as websocket_router
from app.api.conversations import router as conversations_router

app = FastAPI(
    title="Chatbot API",
    description="API de chatbot que usa reglas dinámicas desde Base de Datos y WebSocket.",
    version="1.0.0",
)

# 2. Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],        # Permite peticiones desde cualquier origen (Frontend)
    allow_credentials=True,
    allow_methods=["*"],        # Habilita OPTIONS, POST, GET, etc.
    allow_headers=["*"],        # Permite todos los encabezados
)

# 3. Incluir tus routers
app.include_router(chatbot_router)
app.include_router(websocket_router)
app.include_router(conversations_router)


@app.get("/")
def root():
    return {
        "mensaje": "API del Chatbot funcionando",
        "endpoints": [
            "/api/chatbot/chat", 
            "/api/chatbot/rules", 
            "/ws/chat",
            "/chatbot/conversation",
            "/chatbot/obtenerconversation"
        ],
    }