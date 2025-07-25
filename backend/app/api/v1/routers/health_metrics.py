# In app/api/v1/routers/health_metrics.py

from fastapi import APIRouter, Depends, status, HTTPException, Response
from sqlalchemy.orm import Session
from typing import List
import uuid

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

@router.put("/{metric_id}", response_model=health_metric_schemas.HealthMetric)
def update_health_metric(
    metric_id: uuid.UUID,
    metric_update: health_metric_schemas.HealthMetricUpdate,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    db_metric = db.query(health_metric_models.HealthMetric).filter(health_metric_models.HealthMetric.metric_id == metric_id).first()
    
    if not db_metric:
        raise HTTPException(status_code=404, detail="Metric not found")
    if db_metric.user_id != uuid.UUID(current_user.user_id):
        raise HTTPException(status_code=403, detail="Not authorized to update this metric")
        
    update_data = metric_update.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_metric, key, value)
        
    db.commit()
    db.refresh(db_metric)
    return db_metric

# --- DELETE ENDPOINT ---
@router.delete("/{metric_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_health_metric(
    metric_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    db_metric = db.query(health_metric_models.HealthMetric).filter(health_metric_models.HealthMetric.metric_id == metric_id).first()
    
    if not db_metric:
        raise HTTPException(status_code=404, detail="Metric not found")
    if db_metric.user_id != uuid.UUID(current_user.user_id):
        raise HTTPException(status_code=403, detail="Not authorized to delete this metric")
        
    db.delete(db_metric)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)