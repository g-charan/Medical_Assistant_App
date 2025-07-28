# In app/api/v1/routers/files.py

from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List

from app.core.database import SessionLocal
# Corrected import
from app.api.v1.models import file_models
from app.api.v1.schemas import file_schemas
from app.api.v1.dependencies.auth import get_current_user, TokenData

router = APIRouter() # Corrected typo here

# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=file_schemas.File, status_code=status.HTTP_201_CREATED)
def create_file_record(
    file_data: file_schemas.FileCreate,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Create a new file record in the database for the authenticated user.
    The actual file should be uploaded to Supabase Storage first.
    """
    new_file_record = file_models.File(
        user_id=current_user.user_id,
        file_url=file_data.file_url,
        file_type=file_data.file_type,
        description=file_data.description
    )
    db.add(new_file_record)
    db.commit()
    db.refresh(new_file_record)
    return new_file_record


@router.get("/", response_model=List[file_schemas.File])
def get_files_for_user(
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Get a list of all file records for the authenticated user.
    """
    files = db.query(file_models.File).filter(
        file_models.File.user_id == current_user.user_id
    ).order_by(file_models.File.uploaded_at.desc()).all()
    return files