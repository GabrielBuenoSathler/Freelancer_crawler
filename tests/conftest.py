"""Shared pytest fixtures and test setup.

`conftest.py` is automatically loaded by pytest *before* any test module is
imported. We use that to set the environment variables that the backend reads
at import time (otherwise `security.py` raises because SECRET_KEY is missing).
"""

import os

# --- env must be set BEFORE importing the app modules ---------------------
# `setdefault` means: only set if not already present, so real env vars and
# the CI environment still win.
os.environ.setdefault("SECRET_KEY", "test-secret-key-not-for-production")
os.environ.setdefault("POSTGRES_USER", "test")
os.environ.setdefault("POSTGRES_PASSWORD", "test")
os.environ.setdefault("POSTGRES_DB", "test")
os.environ.setdefault("DB_HOST", "localhost")
os.environ.setdefault("DB_PORT", "5432")

import pytest
from fastapi.testclient import TestClient

# These imports work because `pythonpath = ["src/freelancer_crawler"]` is set
# in pyproject.toml, putting the backend modules on sys.path.
from main import app
from connect import get_db
from security import get_current_user


# -------------------------------------------------------------------------
# Fake database connection
# -------------------------------------------------------------------------
# The real `get_db` yields a psycopg connection used like:
#     conn.execute(sql, params).fetchone()
# We replace it with a tiny fake so tests never touch a real database.
class FakeResult:
    def __init__(self, row):
        self._row = row

    def fetchone(self):
        return self._row


class FakeConn:
    """Stand-in for the psycopg connection yielded by get_db.

    Any .execute(...).fetchone() returns the single `row` it was built with
    (a dict, mimicking psycopg's dict_row, or None to simulate "not found").
    """

    def __init__(self, row=None):
        self.row = row

    def execute(self, *args, **kwargs):
        return FakeResult(self.row)


# -------------------------------------------------------------------------
# Fixtures
# -------------------------------------------------------------------------
@pytest.fixture
def client():
    """Plain TestClient with no dependency overrides."""
    return TestClient(app)


@pytest.fixture
def override_db():
    """Override get_db so it yields a FakeConn returning `row`.

    Usage in a test:
        override_db({"email": "a@b.com", "password": hashed})
    Overrides are cleared automatically after the test.
    """

    def _apply(row=None):
        app.dependency_overrides[get_db] = lambda: FakeConn(row)

    yield _apply
    app.dependency_overrides.clear()


@pytest.fixture
def authed_client():
    """TestClient where authentication is bypassed.

    `get_current_user` is overridden to return user id 1, so protected routes
    can be tested without generating a real JWT or hitting the database.
    """
    app.dependency_overrides[get_current_user] = lambda: 1
    yield TestClient(app)
    app.dependency_overrides.clear()
