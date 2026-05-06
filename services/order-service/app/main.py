from fastapi import FastAPI

app = FastAPI(title="Order Service")


@app.get("/")
@app.get("/orders")
def list_orders():
    return {
        "service": "order-service",
        "status": "running",
        "orders": [],
    }


@app.get("/health")
@app.get("/orders/health")
def health_check():
    return {"status": "healthy"}
