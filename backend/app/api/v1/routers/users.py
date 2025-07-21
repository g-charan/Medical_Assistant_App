from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.database import SessionLocal
from app.api.v1.models import user_models
from app.api.v1.schemas import user_schemas
from app.api.v1.services import user_services

router = APIRouter()

# Dependency to get a database session for each request
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/register", response_model=user_schemas.User, status_code=status.HTTP_201_CREATED)
def create_user(user: user_schemas.UserCreate, db: Session = Depends(get_db)):
    """
    Create a new user in the database.
    """
    # First, check if a user with this email already exists
    db_user = db.query(user_models.User).filter(user_models.User.email == user.email).first()
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered."
        )

    # Hash the password before storing it
    hashed_password = user_services.get_password_hash(user.password)

    # Create a new User database object
    new_user = user_models.User(
        email=user.email,
        name=user.name,
        password_hash=hashed_password,
        phone=user.phone,
        gender=user.gender,
        date_of_birth=user.date_of_birth
    )

    # Add the new user to the database, commit, and refresh
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user