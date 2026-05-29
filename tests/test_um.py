"""Smoke tests that hit real external sites.

These depend on the internet and on third-party sites being up, so they are
marked `network` and are *deselected in CI* (`-m "not network"`). Run them
locally with:  pytest -m network
"""

import pytest
import requests


@pytest.mark.network
def test_99freelas_connection():
    r = requests.get(
        "https://www.99freelas.com.br/projects?categoria=web-mobile-e-software",
        timeout=5,
    )
    assert r.status_code == 200
    assert "Freelas" in r.text  # garante que veio algo esperado


@pytest.mark.network
def test_workana_connection():
    r = requests.get(
        "https://www.workana.com/jobs?category=it-programming&language=pt",
        timeout=5,
    )
    assert r.status_code == 200
