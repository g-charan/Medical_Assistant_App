from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
import uuid

from app.core.database import SessionLocal
from app.api.v1.models import profile_models
from app.api.v1.schemas import profile_schemas
from app.api.v1.dependencies.auth import get_current_user, TokenData

router = APIRouter()

# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/me", response_model=profile_schemas.Profile)
def read_current_user_profile(
    current_user: TokenData = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get the profile of the currently authenticated user.
    """
    profile = db.query(profile_models.Profile).filter(profile_models.Profile.id == current_user.user_id).first()
    return profile

@router.put("/me", response_model=profile_schemas.Profile)
def update_current_user_profile(
    profile_update: profile_schemas.ProfileUpdate,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Update the profile for the currently authenticated user.
    """
    # Get the user's current profile from the database
    profile = db.query(profile_models.Profile).filter(profile_models.Profile.id == uuid.UUID(current_user.user_id)).first()
    
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")

    # Get the data from the request, excluding any fields that weren't sent
    update_data = profile_update.dict(exclude_unset=True)
    
    # Update the profile object with the new data
    for key, value in update_data.items():
        setattr(profile, key, value)
        
    db.commit()
    db.refresh(profile)
    return profile


@router.get("/", response_model=List[profile_schemas.Profile])
def read_all_profiles(
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100
):
    """
    Retrieve a list of all user profiles.
    """
    profiles = db.query(profile_models.Profile).offset(skip).limit(limit).all()
    return profiles