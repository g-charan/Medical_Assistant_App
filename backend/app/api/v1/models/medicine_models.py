# In app/api/v1/models/medicine_models.py

from sqlalchemy import Column, String, Date, Boolean, ForeignKey, text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.core.database import Base

# This model represents the master list of all possible medicines
class Medicine(Base):
    __tablename__ = "medicines"

    medicine_id = Column(UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"))
    name = Column(String, nullable=False, index=True)
    generic_name = Column(String)
    manufacturer = Column(String)
    usage = Column(String)
    dosage = Column(String)
    side_effects = Column(String)
    interactions = Column(String)
    precautions = Column(String)
    storage = Column(String)
    created_at = Column(Date, server_default=text('CURRENT_TIMESTAMP'))


# This model links a specific user to a specific medicine from the master list
class UserMedicine(Base):
    __tablename__ = "user_medicines"

    id = Column(UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"))
    user_id = Column(UUID(as_uuid=True), ForeignKey("profiles.id"), nullable=False)
    medicine_id = Column(UUID(as_uuid=True), ForeignKey("medicines.medicine_id"), nullable=False)
    start_date = Column(Date)
    end_date = Column(Date)
    notes = Column(String)
    is_active = Column(Boolean, default=True)
    created_at = Column(Date, server_default=text('CURRENT_TIMESTAMP'))


    # Create relationships to easily access related data
    medicine = relationship("Medicine")
    owner = relationship("Profile")