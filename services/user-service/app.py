import os

from flask import Flask, jsonify


app = Flask(__name__)


@app.get("/")
@app.get("/users")
@app.get("/users/<path:_path>")
def index():
    return jsonify({"service": "user-service", "status": "running"})


@app.get("/health")
def health():
    return jsonify({"status": "healthy"})


if __name__ == "__main__":
    port = int(os.getenv("PORT", "5000"))
    app.run(host="0.0.0.0", port=port)
