# In app/api/v1/routers/relationships.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import text 
from typing import List
import uuid

from app.core.database import SessionLocal
from app.api.v1.models import profile_models, relationship_models
from app.api.v1.schemas import relationship_schemas
from app.api.v1.dependencies.auth import get_current_user, TokenData

router = APIRouter()

# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=relationship_schemas.Relationship, status_code=status.HTTP_201_CREATED)
def add_relationship(
    relationship_data: relationship_schemas.RelationshipCreate,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Create a new family relationship for the authenticated user.
    """
    # Find the profile of the user to be added by their email
    stmt = text("SELECT * FROM get_profile_by_email(:email)")
    related_user_profile = db.execute(stmt, {"email": relationship_data.related_user_email}).first()

    if not related_user_profile:
        raise HTTPException(status_code=404, detail="User with the specified email not found.")

    # Check if the user is trying to add themselves
    if related_user_profile.id == uuid.UUID(current_user.user_id):
        raise HTTPException(status_code=400, detail="You cannot add yourself as a family member.")

    # Check if the relationship already exists
    existing_relationship = db.query(relationship_models.UserRelationship).filter(
        relationship_models.UserRelationship.user_id == current_user.user_id,
        relationship_models.UserRelationship.related_user_id == related_user_profile.id
    ).first()

    if existing_relationship:
        raise HTTPException(status_code=400, detail="This user is already in your family list.")

    # Create the new relationship entry
    new_relationship = relationship_models.UserRelationship(
        user_id=current_user.user_id,
        related_user_id=related_user_profile.id,
        relation=relationship_data.relation,
        permission=relationship_data.permission
    )
    db.add(new_relationship)
    db.commit()
    db.refresh(new_relationship)

    return new_relationship


@router.get("/", response_model=List[relationship_schemas.Relationship])
def get_relationships(
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Get a list of all family members for the authenticated user.
    """
    relationships = db.query(relationship_models.UserRelationship).filter(
        relationship_models.UserRelationship.user_id == current_user.user_id
    ).all()
    return relationships