from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import date, datetime
import uuid

# Shared properties that all user schemas will have
class UserBase(BaseModel):
    email: EmailStr
    name: str
    phone: Optional[str] = None
    gender: Optional[str] = None
    date_of_birth: Optional[date] = None

# Properties to receive when creating a new user
class UserCreate(UserBase):
    password: str

# Properties to return when reading user data from the API
class User(UserBase):
    user_id: uuid.UUID
    created_at: datetime

    class Config:
        # This allows the Pydantic model to be created from a database object
        from_attributes = True