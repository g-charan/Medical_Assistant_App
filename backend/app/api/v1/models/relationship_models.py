from sqlalchemy import Column, String, ForeignKey, text, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.core.database import Base
from app.api.v1.models.profile_models import Profile # Import the Profile model

class UserRelationship(Base):
    __tablename__ = "user_relationships"

    relationship_id = Column(UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"))

    # The user who is creating the relationship
    user_id = Column(UUID(as_uuid=True), ForeignKey("profiles.id"), nullable=False)

    # The user who is being added as a family member
    related_user_id = Column(UUID(as_uuid=True), ForeignKey("profiles.id"), nullable=False)

    relation = Column(String, nullable=False)  # e.g., 'father', 'daughter'
    permission = Column(String, nullable=False, default='viewer') # e.g., 'viewer', 'editor'

    # This constraint ensures you can't add the same person twice
    __table_args__ = (UniqueConstraint('user_id', 'related_user_id', name='_user_related_user_uc'),)

    # Define relationships to easily access the full profile objects
    user = relationship("Profile", foreign_keys=[user_id])
    related_user = relationship("Profile", foreign_keys=[related_user_id])