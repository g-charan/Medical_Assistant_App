# main.py
from fastapi import FastAPI
from app.api.v1.routers import profiles
from app.api.v1.routers import medicines

app = FastAPI(title = "Medi Help API")
app.include_router(profiles.router, prefix="/api/v1", tags=["Users"])
app.include_router(medicines.router, prefix="/api/v1/medicines", tags=["Medicines"])


@app.get("/", tags=["Root"])
def read_root():
    return {"message": "Welcome to the Medi Help API.!"}
