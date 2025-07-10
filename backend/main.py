# main.py
from fastapi import FastAPI
from openfda_api import get_openfda_info

app = FastAPI()

@app.get("/medicine")
async def get_medicine_info(name: str):
    result = await get_openfda_info(name)
    return result or {"error": "Medicine not found"}
