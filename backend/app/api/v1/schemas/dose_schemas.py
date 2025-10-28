import uuid
from pydantic import BaseModel
from typing import Optional
from datetime import datetime, time

# Base properties shared by all Dose schemas
class DoseBase(BaseModel):
    dose_time: time
    quantity: Optional[str] = "1 pill"

# Properties required when creating a new dose
class DoseCreate(DoseBase):
    user_medicine_id: uuid.UUID

class DoseUpdate(BaseModel):
    dose_time: Optional[time] = None
    quantity: Optional[str] = None
    
# Properties to return to the client (the full Dose object)
class Dose(DoseBase):
    dose_id: uuid.UUID
    user_medicine_id: uuid.UUID
    created_at: datetime

    class Config:
        from_attributes = True # Pydantic v2+ uses this, (orm_mode = True for v1)
        
# Properties that can be updated on an existing dose
