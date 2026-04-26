import requests

def test_99freelas_connection():
    r = requests.get(
        'https://www.99freelas.com.br/projects?categoria=web-mobile-e-software',
        timeout=5
    )
    
    assert r.status_code == 200
    assert "Freelas" in r.text  # garante que veio algo esperado


def test_workana_connection():
 r = requests.get(                                                                  
     'https://www.workana.com/jobs?category=it-programming&language=pt',       
     timeout=5                                                                      
 )                                                                                  
                                                                                    
 assert r.status_code == 200                                                        
                       
