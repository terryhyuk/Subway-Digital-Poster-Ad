from fastapi import FastAPI
from machine_learning import router as ml_router

app = FastAPI()

app.include_router(ml_router, prefix="/ml", tags=["ml"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host = "127.0.0.1", port = 8000)
