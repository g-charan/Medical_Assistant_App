from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime
import uuid

# Base properties for a profile
class ProfileBase(BaseModel):
    name: Optional[str] = None
    phone: Optional[str] = None
    gender: Optional[str] = None
    date_of_birth: Optional[date] = None

# Properties to return from the API
class Profile(ProfileBase):
    id: uuid.UUID
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True