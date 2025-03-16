from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello from FastAPI running with Tailscale in IBM Cloud Code Engine!"}
