"""API tests using FastAPI's TestClient.

These show two key techniques:
  1. Dependency overrides (replace get_db / get_current_user with fakes).
  2. monkeypatch (replace a function the route calls).
Both let us test routes without a real database.
"""

from security import get_password_hash


def test_root_returns_hello_world(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}


def test_login_success_returns_token(client, override_db):
    password = "minha-senha"
    override_db({"email": "ana@example.com", "password": get_password_hash(password)})

    response = client.post(
        "/token",
        data={"username": "ana@example.com", "password": password},
    )

    assert response.status_code == 200
    body = response.json()
    assert body["token_type"] == "bearer"
    assert body["access_token"]


def test_login_wrong_password_is_rejected(client, override_db):
    override_db({"email": "ana@example.com", "password": get_password_hash("correta")})

    response = client.post(
        "/token",
        data={"username": "ana@example.com", "password": "errada"},
    )

    assert response.status_code == 401


def test_login_unknown_user_is_rejected(client, override_db):
    override_db(None)  # simulate "no row found"

    response = client.post(
        "/token",
        data={"username": "ghost@example.com", "password": "x"},
    )

    assert response.status_code == 401


def test_profile_returns_db_result(authed_client, monkeypatch):
    import main

    monkeypatch.setattr(
        main, "db_profile", lambda user_id: [{"nivel": "senior", "skill": "python"}]
    )

    response = authed_client.get("/profile")

    assert response.status_code == 200
    assert response.json() == [{"nivel": "senior", "skill": "python"}]


def test_match_without_profile_returns_400(authed_client, monkeypatch):
    import main

    # No skills found for this user -> route should refuse with 400.
    monkeypatch.setattr(main, "get_skills", lambda user_id: [])

    response = authed_client.get("/match_vagas")

    assert response.status_code == 400
