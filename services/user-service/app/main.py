from fastapi import FastAPI

app = FastAPI(title="User Service")


@app.get("/")
@app.get("/users")
def list_users():
    return {
        "service": "user-service",
        "status": "running",
        "users": [],
    }


@app.get("/health")
@app.get("/users/health")
def health_check():
    return {"status": "healthy"}
