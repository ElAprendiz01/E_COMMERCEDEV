from typing import List, Union, Dict, Any, Optional
from pydantic import BaseModel
from datetime import datetime

class Metadata(BaseModel):
    type: str
    entity: str
    fields: List[str]
    data: Union[List[Dict[str, Any]], Dict[str, Any]]

class Message(BaseModel):
    role: str
    timestamp: datetime
    intent: str
    content: str
    metadata: Optional[Metadata] = None

class Context(BaseModel):
    language: str
    session_variables: Dict[str, Any]

class Conversation(BaseModel):
    conversation_id: str
    user_id: str
    messages: List[Message]
    context: Context

class ConversationRequest(BaseModel):
    conversation_id: str