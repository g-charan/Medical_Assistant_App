# In app/api/v1/schemas/health_metric_schemas.py

from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import uuid

# This is the data the user will send to log a new metric
class HealthMetricCreate(BaseModel):
    metric_type: str
    value: str
    unit: Optional[str] = None
    timestamp: Optional[datetime] = None

# This is the data object the API will return
class HealthMetric(HealthMetricCreate):
    metric_id: uuid.UUID
    user_id: uuid.UUID
    # Override timestamp to ensure it's not optional when returned
    timestamp: datetime

    class Config:
        from_attributes = True
        
# Add this class to health_metric_schemas.py

# This schema defines the fields a user can update
class HealthMetricUpdate(BaseModel):
    metric_type: Optional[str] = None
    value: Optional[str] = None
    unit: Optional[str] = None
    timestamp: Optional[datetime] = None