# In app/main.py
from fastapi import FastAPI
# Use relative imports for files within the same 'app' package
from app.api.v1.routers import profiles, medicines, relationships, files, health_metrics
from AI.routers import ai, files_ai # We will integrate the AI router correctly

app = FastAPI(title="Medi Help API")

# Include all the routers
app.include_router(profiles.router, prefix="/api/v1/profiles", tags=["Profiles"])
app.include_router(medicines.router, prefix="/api/v1/medicines", tags=["Medicines"])
app.include_router(relationships.router, prefix="/api/v1/relationships", tags=["Relationships"])
app.include_router(files.router, prefix="/api/v1/files", tags=["Files"])
app.include_router(health_metrics.router, prefix="/api/v1/health_metrics", tags=["Health Metrics"])
app.include_router(ai.router, prefix="/api/v1/ai", tags=["AI"])
app.include_router(files_ai.router, prefix="/api/v1/ai/files", tags=["AI File Processing"])

@app.get("/")
def read_root():
    return {"message": "Welcome to the Medi Help API!"}