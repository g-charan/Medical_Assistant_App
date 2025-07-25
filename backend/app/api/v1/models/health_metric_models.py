# In app/api/v1/models/health_metric_models.py

from sqlalchemy import Column, String, ForeignKey, text, TIMESTAMP
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.core.database import Base
from app.api.v1.models.profile_models import Profile

class HealthMetric(Base):
    __tablename__ = "health_metrics"

    metric_id = Column(UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"))

    user_id = Column(UUID(as_uuid=True), ForeignKey("profiles.id"), nullable=False)

    metric_type = Column(String, nullable=False, index=True) # e.g., 'blood_pressure', 'glucose'
    value = Column(String, nullable=False) # Stored as string to be flexible (e.g., "120/80")
    unit = Column(String) # e.g., 'mmHg', 'mg/dL'

    timestamp = Column("timestamp", TIMESTAMP(timezone=True), nullable=False, server_default=text('now()'))

    # Define a relationship to easily access the owner's profile
    owner = relationship("Profile")
    
