# In AI/schemas/ai_schemas.py

from pydantic import BaseModel
import uuid

# This defines the data the frontend will send when asking a question
class ChatRequest(BaseModel):
    medicine_id: uuid.UUID
    prompt: str

# This defines the data the backend will send back as a response
class ChatResponse(BaseModel):
    response: str
    
# This is the data the frontend will send from the OCR scan
class OcrRequest(BaseModel):
    text: str

# This is the structured data the backend will return
class OcrResponse(BaseModel):
    name: str
    description: str