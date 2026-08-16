from fastapi import FastAPI
from presentation.controllers import conversation_controller

app = FastAPI()
app.include_router(conversation_controller.router)