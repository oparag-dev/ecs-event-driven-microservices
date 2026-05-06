from fastapi import FastAPI

app = FastAPI(title="Notification Service")


@app.get("/")
@app.get("/notifications")
def list_notifications():
    return {
        "service": "notification-service",
        "status": "running",
        "notifications": [],
    }


@app.get("/health")
@app.get("/notifications/health")
def health_check():
    return {"status": "healthy"}
