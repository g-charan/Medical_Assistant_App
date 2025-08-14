# In AI/schemas/ai_schemas.py

from pydantic import BaseModel
from typing import List
import uuid

# --- Schemas for sending a chat message ---
class ChatRequest(BaseModel):
    medicine_id: uuid.UUID
    prompt: str

class ChatResponse(BaseModel):
    response: str

# --- Schemas for retrieving chat history ---
class ChatMessagePart(BaseModel):
    text: str

class ChatMessage(BaseModel):
    role: str
    parts: List[ChatMessagePart]

class ChatHistoryResponse(BaseModel):
    history: List[ChatMessage]

# --- Schemas for OCR analysis ---
class OcrRequest(BaseModel):
    text: str

class OcrResponse(BaseModel):
    name: str
    description: str