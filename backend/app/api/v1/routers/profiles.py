from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.database import SessionLocal
from app.api.v1.models import user_models
from backend.app.api.v1.schemas import profile_schemas
from typing import List

# Import 'get_current_user' and also 'TokenData' from the auth dependency
from app.api.v1.dependencies.auth import get_current_user, TokenData

router = APIRouter()

# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db    
    finally:
        db.close()

@router.get("/me", response_model=profile_schemas.User)
def read_users_me(
    # Use 'TokenData' directly, not 'user_schemas.TokenData'
    current_user: TokenData = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get the profile of the currently authenticated user.
    """
    # Note: The SQLAlchemy model uses 'id', not 'user_id' for the primary key
    user = db.query(user_models.User).filter(user_models.User.id == current_user.user_id).first()
    return user

@router.get("/", response_model=List[profile_schemas.User])
def read_users(
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100
):
    """
    Retrieve a list of all user profiles.
    """
    users = db.query(user_models.User).offset(skip).limit(limit).all()
    return users        
