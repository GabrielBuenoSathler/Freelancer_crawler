import requests
import json


url = "http://127.0.0.1:8000/vagas_99freelas"


def teste(url: str) -> list[tuple[str, str]]:
    response = requests.get(url)
    data = response.json()

    # se vier como string
    if isinstance(data, str):
        data = json.loads(data)

    # se vier encapsulado
    if isinstance(data, dict):
        # tenta achar lista dentro
        for key in data:
            if isinstance(data[key], list):
                data = data[key]
                break

    return [(item["titulo"], item["link"]) for item in data]

print(teste(url))



