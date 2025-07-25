# In app/api/v1/routers/health_metrics.py

from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List

from app.core.database import SessionLocal
from app.api.v1.models import health_metric_models
from app.api.v1.schemas import health_metric_schemas
from app.api.v1.dependencies.auth import get_current_user, TokenData

router = APIRouter()

# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=health_metric_schemas.HealthMetric, status_code=status.HTTP_201_CREATED)
def create_health_metric(
    metric_data: health_metric_schemas.HealthMetricCreate,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Log a new health metric for the authenticated user.
    """
    new_metric = health_metric_models.HealthMetric(
        user_id=current_user.user_id,
        metric_type=metric_data.metric_type,
        value=metric_data.value,
        unit=metric_data.unit,
        timestamp=metric_data.timestamp  # Use timestamp from user if provided
    )
    db.add(new_metric)
    db.commit()
    db.refresh(new_metric)
    return new_metric


@router.get("/", response_model=List[health_metric_schemas.HealthMetric])
def get_health_metrics(
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Get a list of all health metrics for the authenticated user.
    """
    metrics = db.query(health_metric_models.HealthMetric).filter(
        health_metric_models.HealthMetric.user_id == current_user.user_id
    ).order_by(health_metric_models.HealthMetric.timestamp.desc()).all()
    return metrics