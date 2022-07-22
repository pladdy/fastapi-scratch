from fastapi.testclient import TestClient

from fastapi_scratch.main import app

client = TestClient(app)


def test_hello():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"response": "hello world!"}
