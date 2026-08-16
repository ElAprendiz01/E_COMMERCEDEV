from typing import List, Union, Dict, Any, Optional
from pydantic import BaseModel, Field
from datetime import datetime

class Metadata(BaseModel):
    type: Optional[str] = None
    entity: Optional[str] = None
    fields: Optional[List[str]] = None
    data: Optional[Union[List[Dict[str, Any]], Dict[str, Any]]] = None

class MessageIn(BaseModel):
    role: Optional[str] = "user"
    timestamp: Optional[datetime] = None
    intent: Optional[str] = None
    content: Optional[str] = ""
    metadata: Optional[Union[Metadata, Dict[str, Any], str]] = None
    appliedRuleId: Optional[int] = None
    tipo: Optional[str] = None
    productos: Optional[List[Any]] = []

class Context(BaseModel):
    language: Optional[str] = "es"
    session_variables: Optional[Dict[str, Any]] = {}

class ConversationCreate(BaseModel):
    # Acepta userId (alias) y user_id
    userId: str = Field(..., alias="userId")
    user_id: Optional[str] = None
    title: Optional[str] = None
    messages: List[MessageIn] = []
    context: Optional[Context] = None

    class Config:
        # Compatibilidad con Pydantic v1 y v2: incluir ambas claves
        validate_by_name = True
        allow_population_by_field_name = True
        arbitrary_types_allowed = True

class ConversationRequest(BaseModel):
    conversation_id: Union[int, str]

# Clase que tu router "conversations.py" o partes del frontend pueden esperar
class Message(BaseModel):
    role: str
    timestamp: Optional[datetime] = None
    intent: Optional[str] = None
    content: str
    metadata: Optional[Union[Metadata, Dict[str, Any], str]] = None

class Conversation(BaseModel):
    conversation_id: Union[int, str]
    user_id: str
    messages: List[Message] = []
    context: Optional[Context] = None

# Para crear conversaciones desde UI (si usas este modelo en algún lugar)
class CreateConversationRequest(BaseModel):
    userId: str
    title: Optional[str] = None
