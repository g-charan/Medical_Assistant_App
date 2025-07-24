from pydantic import BaseModel, EmailStr
from typing import Optional
import uuid
from . import profile_schemas

# This is the data the user will send to add a new family member
class RelationshipCreate(BaseModel):
    related_user_email: EmailStr # User adds a member by their email
    relation: str # e.g., "Father", "Mother", "Spouse"
    permission: Optional[str] = 'viewer'

# This is the rich data object the API will return when listing family members
class Relationship(BaseModel):
    relationship_id: uuid.UUID
    relation: str
    permission: str
    # We include the full profile of the related user
    related_user: profile_schemas.Profile

    class Config:
        from_attributes = True