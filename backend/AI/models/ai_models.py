# In AI/models/ai_models.py

from sqlalchemy import Column, ForeignKey, text, TIMESTAMP
from sqlalchemy.dialects.postgresql import UUID, JSONB
from app.core.database import Base

class AIChatHistory(Base):
    # Fill in the blank below with the correct table name
    __tablename__ = "ai_chat_histories"

    history_id = Column(UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"))
    user_id = Column(UUID(as_uuid=True), ForeignKey("profiles.id"), nullable=False)
    medicine_id = Column(UUID(as_uuid=True), ForeignKey("medicines.medicine_id"), nullable=False)
    history = Column(JSONB, nullable=False)
    created_at = Column(TIMESTAMP(timezone=True), server_default=text('now()'))
    updated_at = Column(TIMESTAMP(timezone=True), server_default=text('now()'), onupdate=text('now()'))