# In app/api/v1/schemas/file_schemas.py

from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import uuid

# This is the data the user will send when creating a file record
class FileCreate(BaseModel):
    # Correct field name
    file_url: str
    file_type: Optional[str] = None
    description: Optional[str] = None

# This is the data object the API will return after a file record is created
class File(BaseModel):
    file_id: uuid.UUID
    user_id: uuid.UUID
    file_url: str
    file_type: Optional[str] = None
    description: Optional[str] = None
    # Correct field name
    uploaded_at: datetime

    class Config:
        from_attributes = True
        
# Data the frontend sends to process a file
class FileProcessRequest(BaseModel):
    file_url: str
    file_hash: str
    file_type: Optional[str] = None
    description: Optional[str] = None

# Data the backend sends back after processing
class FileProcessResponse(BaseModel):
    file_id: uuid.UUID
    extracted_text: str

# Data the frontend sends to chat about a processed file
class FileChatRequest(BaseModel):
    file_id: uuid.UUID
    prompt: str