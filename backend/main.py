# In backend/main.py

from fastapi import FastAPI
# Updated imports to work from the project root
from app.api.v1.routers import profiles, medicines, relationships, files, health_metrics
from AI.routers import ai

app = FastAPI(title="Medi Help API")

# Include all the routers from the 'app' module
app.include_router(profiles.router, prefix="/api/v1/profiles", tags=["Profiles"])
app.include_router(medicines.router, prefix="/api/v1/medicines", tags=["Medicines"])
app.include_router(relationships.router, prefix="/api/v1/relationships", tags=["Relationships"])
app.include_router(files.router, prefix="/api/v1/files", tags=["Files"])
app.include_router(health_metrics.router, prefix="/api/v1/health_metrics", tags=["Health Metrics"])
app.include_router(ai.router, prefix="/api/v1/ai", tags=["AI"])

@app.get("/", tags=["Root"])
def read_root():
    return {"message": "Welcome to the Medi Help API!"}