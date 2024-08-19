import os
import requests
from fastapi import FastAPI, HTTPException

app = FastAPI()

@app.get("/{path:path}")
def fetch_url_response(path: str):
    url = os.environ.get("API_URL")
    if url:
        url += f"/{path}"
        try:
            response = requests.get(url)
            return response.content
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Error fetching data from {url}: {e}")
    else:
        raise HTTPException(status_code=500, detail="API_URL environment variable not set")

@app.get("/ready")
def check_ready():
    return {"status": "OK"}