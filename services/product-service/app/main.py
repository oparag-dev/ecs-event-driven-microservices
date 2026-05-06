from fastapi import FastAPI

app = FastAPI(title="Product Service")


@app.get("/")
@app.get("/products")
def list_products():
    return {
        "service": "product-service",
        "status": "running",
        "products": [],
    }


@app.get("/health")
@app.get("/products/health")
def health_check():
    return {"status": "healthy"}
