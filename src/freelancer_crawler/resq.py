import requests
import json
# The API endpoint
url = "http://127.0.0.1:8000/vagas_99freelas"
def teste(url): 
 response = requests.get(url)
 json_data= response.json()
 data = json.loads(json_data)
 vagas = []
 for item in data:              
    vagas.append(item["titulo"])
 return vagas



