from fastapi import FastAPI
import random

app = FastAPI()

@app.get("/odd")
def get_random_odd():
    return {"random_odd": random.choice([i for i in range(1, 21) if i % 2 != 0])}

@app.get("/even")
def get_random_even():
    return {"random_even": random.choice([i for i in range(1, 21) if i % 2 == 0])}

@app.get("/ready")
def check_ready():
    return {"status": "OK"}