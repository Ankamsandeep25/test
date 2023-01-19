from app import app


def test_index():
    client = app.test_client()
    response = client.get('/')
    assert response.status_code == 200


def test_index_response():
    client = app.test_client()
    response = client.get('/')
    assert b"Employee Data" in response.data