from pydantic import BaseModel
from typing import Optional
from datetime import date
import uuid

# --- Schemas for the Master Medicine Library ---
class MedicineBase(BaseModel):
    name: str
    generic_name: Optional[str] = None
    manufacturer: Optional[str] = None
    # Add other general medicine fields if needed for your API

class MedicineCreate(MedicineBase):
    pass

class Medicine(MedicineBase):
    medicine_id: uuid.UUID

    class Config:
        from_attributes = True


# --- Schemas for a User's Specific Medicine Entry ---
class UserMedicineBase(BaseModel):
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    notes: Optional[str] = None
    is_active: bool = True

# This is the data the user sends to add a medicine to their vault
class UserMedicineCreate(UserMedicineBase):
    medicine_name: str
    manufacturer: Optional[str] = None

# This is the rich data object the API will return
class UserMedicine(UserMedicineBase):
    id: uuid.UUID
    user_id: uuid.UUID
    medicine: Medicine # Notice this includes the full medicine details

    class Config:
        from_attributes = True

# Add this class to medicine_schemas.py
class UserMedicineUpdate(UserMedicineBase):
    # When updating, all fields are optional
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    notes: Optional[str] = None
    is_active: Optional[bool] = None        
