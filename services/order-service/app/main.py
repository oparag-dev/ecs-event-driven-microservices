import os
import json
import boto3
from fastapi import FastAPI

app = FastAPI(title="Order Service")

@app.get("/orders/health")
def health_check():
    return {
        "status": "healthy"
    }

@app.post("/orders")
def create_order():
    queue_url = os.getenv("SQS_QUEUE_URL")

    order_event = {
        "event_type": "ORDER_CREATED",
        "order_id": "demo-order-001",
        "message": "New order created"
    }

    event_sent = False

    if queue_url:
        sqs = boto3.client(
            "sqs",
            region_name=os.getenv("AWS_REGION", "eu-west-3")
        )

        sqs.send_message(
            QueueUrl=queue_url,
            MessageBody=json.dumps(order_event)
        )

        event_sent = True

    return {
        "message": "Order created",
        "event_sent": event_sent,
        "order": order_event
    }
