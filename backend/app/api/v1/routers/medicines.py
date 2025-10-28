from fastapi import APIRouter, Depends, HTTPException, status, Response
from sqlalchemy.orm import Session
from sqlalchemy import select
from typing import List
import uuid

from app.core.database import SessionLocal
from app.api.v1.models import medicine_models
from app.api.v1.schemas import medicine_schemas
from app.api.v1.dependencies.auth import get_current_user, TokenData
from app.api.v1.models import relationship_models

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=medicine_schemas.UserMedicine, status_code=status.HTTP_201_CREATED)
def add_medicine_for_user(user_medicine: medicine_schemas.UserMedicineCreate, db: Session = Depends(get_db), current_user: TokenData = Depends(get_current_user)):
    stmt = select(medicine_models.Medicine).where(medicine_models.Medicine.name.ilike(user_medicine.medicine_name))
    db_medicine = db.execute(stmt).scalars().first()
    if db_medicine is None:
        db_medicine = medicine_models.Medicine(name=user_medicine.medicine_name, manufacturer=user_medicine.manufacturer)
        db.add(db_medicine)
        db.commit()
        db.refresh(db_medicine)
    new_user_medicine = medicine_models.UserMedicine(user_id=current_user.user_id, medicine_id=db_medicine.medicine_id, **user_medicine.dict(exclude={"medicine_name", "manufacturer"}))
    db.add(new_user_medicine)
    db.commit()
    db.refresh(new_user_medicine)
    return new_user_medicine

@router.get("/", response_model=List[medicine_schemas.UserMedicine])
def get_medicines_for_user(db: Session = Depends(get_db), current_user: TokenData = Depends(get_current_user)):
    user_medicines = db.query(medicine_models.UserMedicine).filter(medicine_models.UserMedicine.user_id == current_user.user_id).all()
    return user_medicines

# --- UPDATE ENDPOINT ---
@router.put("/{user_medicine_id}", response_model=medicine_schemas.UserMedicine)
def update_user_medicine(
    user_medicine_id: uuid.UUID,
    medicine_update: medicine_schemas.UserMedicineUpdate,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    db_user_medicine = db.query(medicine_models.UserMedicine).filter(medicine_models.UserMedicine.id == user_medicine_id).first()
    if not db_user_medicine:
        raise HTTPException(status_code=404, detail="Medicine entry not found")
    if db_user_medicine.user_id != uuid.UUID(current_user.user_id):
        raise HTTPException(status_code=403, detail="Not authorized to update this medicine entry")
    
    update_data = medicine_update.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_user_medicine, key, value)
        
    db.commit()
    db.refresh(db_user_medicine)
    return db_user_medicine

# --- DELETE ENDPOINT ---
@router.delete("/{user_medicine_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user_medicine(
    user_medicine_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    db_user_medicine = db.query(medicine_models.UserMedicine).filter(medicine_models.UserMedicine.id == user_medicine_id).first()
    if not db_user_medicine:
        raise HTTPException(status_code=404, detail="Medicine entry not found")
    if db_user_medicine.user_id != uuid.UUID(current_user.user_id):
        raise HTTPException(status_code=403, detail="Not authorized to delete this medicine entry")
        
    db.delete(db_user_medicine)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)