from fastapi import APIRouter, Depends, status, HTTPException, Response
from sqlalchemy.orm import Session
from typing import List
import uuid

from app.core.database import SessionLocal
from app.api.v1.models import dose_models, medicine_models, relationship_models
from app.api.v1.schemas import dose_schemas
from app.api.v1.dependencies.auth import get_current_user, TokenData

router = APIRouter()

# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# --- Helper Function to Check Permissions ---
def get_medicine_and_check_permission(
    db: Session, 
    user_medicine_id: uuid.UUID, 
    admin_id: uuid.UUID, 
    permission_level: str = 'viewer'
) -> medicine_models.UserMedicine:
    """
    Checks if the admin has the required permission level ('viewer' or 'editor') 
    for a specific UserMedicine object.
    """
    # 1. Get the UserMedicine object
    user_medicine = db.query(medicine_models.UserMedicine).filter(
        medicine_models.UserMedicine.id == user_medicine_id
    ).first()

    if not user_medicine:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Medicine not found")

    # 2. Check if the admin is the direct owner
    if user_medicine.user_id == admin_id:
        return user_medicine # Permission granted

    # 3. If not the owner, check family relationship
    required_permissions = ['editor']
    if permission_level == 'viewer':
        required_permissions.append('viewer') # For 'viewer', both 'viewer' and 'editor' are ok

    permission = db.query(relationship_models.UserRelationship).filter(
        relationship_models.UserRelationship.user_id == admin_id,
        relationship_models.UserRelationship.related_user_id == user_medicine.user_id,
        relationship_models.UserRelationship.permission.in_(required_permissions)
    ).first()

    if not permission:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"Not authorized to perform this action. Requires '{permission_level}' permission."
        )
    
    return user_medicine


# --- API Endpoints ---

@router.post("/", response_model=dose_schemas.Dose, status_code=status.HTTP_201_CREATED)
def create_dose_for_medicine(
    dose_data: dose_schemas.DoseCreate,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Create a new dose schedule for a specific medicine.
    Only the owner or a family 'editor' can create doses.
    """
    admin_id = uuid.UUID(current_user.user_id)
    
    # Check if the user has 'editor' permission for this medicine
    get_medicine_and_check_permission(
        db, 
        user_medicine_id=dose_data.user_medicine_id, 
        admin_id=admin_id, 
        permission_level='editor'
    )
    
    # Permission granted, create the dose
    new_dose = dose_models.Dose(**dose_data.dict())
    db.add(new_dose)
    db.commit()
    db.refresh(new_dose)
    return new_dose


@router.get("/for-medicine/{user_medicine_id}", response_model=List[dose_schemas.Dose])
def get_doses_for_medicine(
    user_medicine_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Get all dose schedules for a specific medicine.
    Only the owner or a family 'viewer'/'editor' can see them.
    """
    admin_id = uuid.UUID(current_user.user_id)
    
    # Check if user has 'viewer' permission for this medicine
    get_medicine_and_check_permission(
        db, 
        user_medicine_id=user_medicine_id, 
        admin_id=admin_id, 
        permission_level='viewer'
    )

    # Permission granted, get the doses
    doses = db.query(dose_models.Dose).filter(
        dose_models.Dose.user_medicine_id == user_medicine_id
    ).order_by(dose_models.Dose.dose_time).all()
    
    return doses

# ... (after the get_doses_for_medicine function)

@router.put("/{dose_id}", response_model=dose_schemas.Dose)
def update_dose(
    dose_id: uuid.UUID,
    dose_update: dose_schemas.DoseUpdate,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Update a specific dose schedule (time or quantity).
    Only the owner or a family 'editor' can update doses.
    """
    admin_id = uuid.UUID(current_user.user_id)

    # 1. Get the dose from the DB
    db_dose = db.query(dose_models.Dose).filter(dose_models.Dose.dose_id == dose_id).first()
    if not db_dose:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Dose not found")

    # 2. Check if user has 'editor' permission for the parent medicine
    get_medicine_and_check_permission(
        db, 
        user_medicine_id=db_dose.user_medicine_id, 
        admin_id=admin_id, 
        permission_level='editor'
    )
    
    # 3. Permission granted, update the data
    # Get the update data, excluding any fields that weren't set (i.e., are None)
    update_data = dose_update.dict(exclude_unset=True)
    
    for key, value in update_data.items():
        setattr(db_dose, key, value)
        
    db.commit()
    db.refresh(db_dose)
    
    return db_dose

@router.delete("/{dose_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_dose(
    dose_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Delete a specific dose schedule.
    Only the owner or a family 'editor' can delete doses.
    """
    admin_id = uuid.UUID(current_user.user_id)

    # 1. Get the dose
    db_dose = db.query(dose_models.Dose).filter(dose_models.Dose.dose_id == dose_id).first()
    if not db_dose:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Dose not found")

    # 2. Check if user has 'editor' permission for the *parent medicine*
    get_medicine_and_check_permission(
        db, 
        user_medicine_id=db_dose.user_medicine_id, 
        admin_id=admin_id, 
        permission_level='editor'
    )
    
    # 3. Permission granted, delete the dose
    db.delete(db_dose)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)