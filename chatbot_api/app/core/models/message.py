from pydantic import BaseModel
from typing import List, Optional

class Message(BaseModel):
    role: str
    content: str
    timestamp: str
    user_id: str  # 👈 este campo faltaba
    isBot: bool = False
    tipo: Optional[str] = None
    productos: Optional[List[str]] = []
    appliedRuleId: Optional[int] = None
