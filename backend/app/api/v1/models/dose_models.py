from sqlalchemy import Column, String, ForeignKey, text, TIMESTAMP, Time
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.core.database import Base
# Import the UserMedicine model to link to it
from .medicine_models import UserMedicine 

class Dose(Base):
    __tablename__ = "doses"

    dose_id = Column(UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"))
    
    # This links the dose to a specific medicine in the user's vault
    # ondelete="CASCADE" means if the user deletes the medicine, their doses for it are also deleted.
    user_medicine_id = Column(UUID(as_uuid=True), ForeignKey("user_medicines.id", ondelete="CASCADE"), nullable=False)
    
    # The time of day for the dose (e.g., 09:00:00)
    # We use Time(timezone=True) to ensure timezones are handled correctly.
    dose_time = Column(Time(timezone=True), nullable=False)
    
    # The amount to take (e.g., "1", "250mg", "1 pill")
    quantity = Column(String, nullable=False, default="1 pill")
    
    created_at = Column(TIMESTAMP(timezone=True), server_default=text('now()'))
    
    # This relationship lets us easily access the UserMedicine object from a Dose object
    user_medicine = relationship("UserMedicine")