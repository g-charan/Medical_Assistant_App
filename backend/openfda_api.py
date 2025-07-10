# openfda_api.py
import httpx

async def get_openfda_info(name: str):
    url = "https://api.fda.gov/drug/label.json"
    params = {"search": f"openfda.brand_name:{name}", "limit": 1}
    
    async with httpx.AsyncClient() as client:
        r = await client.get(url, params=params)
        if r.status_code == 200 and r.json().get("results"):
            data = r.json()["results"][0]
            return {
                "name":name,
                "purpose": data.get("purpose", ["Not specified"])[0],
                "usage": data.get("indications_and_usage", ["Not available"])[0],
                "prescription_required": "Rx only" in data.get("warnings", [""])[0]
            }
        return None
