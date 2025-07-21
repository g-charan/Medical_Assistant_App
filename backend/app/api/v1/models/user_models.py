from sqlalchemy import Column, String, Date, TIMESTAMP, text
from sqlalchemy.dialects.postgresql import UUID
from app.core.database import Base

class User(Base):
    __tablename__ = "users"

    user_id = Column(UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()"))
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    phone = Column(String, unique=True)
    password_hash = Column(String, nullable=False)
    gender = Column(String)
    date_of_birth = Column(Date)
    created_at = Column(TIMESTAMP(timezone=True), nullable=False, server_default=text('now()'))