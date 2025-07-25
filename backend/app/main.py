# main.py
from fastapi import FastAPI
from app.api.v1.routers import profiles
from app.api.v1.routers import medicines
from app.api.v1.routers import relationships
from app.api.v1.routers import health_metrics

app = FastAPI(title = "Medi Help API")
app.include_router(profiles.router, prefix="/api/v1", tags=["Users"])
app.include_router(medicines.router, prefix="/api/v1/medicines", tags=["Medicines"])
app.include_router(relationships.router, prefix="/api/v1/relationships", tags=["Relationships"])
app.include_router(health_metrics.router, prefix="/api/v1/health_metrics", tags=["Health Metrics"])

@app.get("/", tags=["Root"])
def read_root():
    return {"message": "Welcome to the Medi Help API.!"}
