# In app/api/v1/models/profile_models.py

from sqlalchemy import Column, String, Date, TIMESTAMP, text
from sqlalchemy.dialects.postgresql import UUID
from app.core.database import Base

class Profile(Base):
    __tablename__ = "profiles" # This correctly points to your 'profiles' table

    id = Column(UUID(as_uuid=True), primary_key=True) # Matches the 'id' from auth.users
    name = Column(String)
    phone = Column(String, unique=True)
    gender = Column(String)
    date_of_birth = Column(Date)
    updated_at = Column(TIMESTAMP(timezone=True), server_default=text('now()'))