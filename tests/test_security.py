"""Pure unit tests for security.py.

These are the easiest kind of test to start with: no database, no HTTP server,
just functions in / values out.
"""

import jwt

from security import (
    ALGORITHM,
    SECRET_KEY,
    create_access_token,
    get_password_hash,
    verify_password,
)


def test_password_hash_is_not_plaintext():
    hashed = get_password_hash("s3cret")
    assert hashed != "s3cret"


def test_verify_password_accepts_correct_password():
    hashed = get_password_hash("s3cret")
    assert verify_password("s3cret", hashed) is True


def test_verify_password_rejects_wrong_password():
    hashed = get_password_hash("s3cret")
    assert verify_password("wrong-password", hashed) is False


def test_access_token_round_trips_subject():
    token = create_access_token({"sub": "user@example.com"})
    decoded = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    assert decoded["sub"] == "user@example.com"


def test_access_token_has_expiry():
    token = create_access_token({"sub": "user@example.com"})
    decoded = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    assert "exp" in decoded
