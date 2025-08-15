# In app/api/v1/models/file_models.py

from sqlalchemy import Column, String, ForeignKey, text, TIMESTAMP
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.core.database import Base
from app.api.v1.models.profile_models import Profile

class File(Base):
    __tablename__ = "files"

    file_id = Column(UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"))
    user_id = Column(UUID(as_uuid=True), ForeignKey("profiles.id"), nullable=False)
    # This will store the path or URL to the file in Supabase Storage
    file_url = Column(String, nullable=False)
    file_type = Column(String) # e.g., 'pdf', 'image', 'lab_report'
    description = Column(String)
    uploaded_at = Column(TIMESTAMP(timezone=True), nullable=False, server_default=text('now()'))
    file_hash = Column(String, unique=True, index=True) # The unique fingerprint
    extracted_text = Column(String) # The content of the document

    # Define a relationship to easily access the owner's profile
    owner = relationship("Profile")