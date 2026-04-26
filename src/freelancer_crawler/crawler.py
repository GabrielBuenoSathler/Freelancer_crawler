from playwright.sync_api import sync_playwright
from bs4 import BeautifulSoup
import re
import unicodedata
from connect import insere_titulo_link


def transforma_link(text):
    text = unicodedata.normalize('NFKD', text)
    text = text.encode('ascii', 'ignore').decode('ascii')
    text = text.lower()
    text = re.sub(r'[^a-z0-9\s-]', '', text)
    text = re.sub(r'\s+', '-', text)
    return text.rstrip('-')


titles = []

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()

    # -------------------------
    # 99Freelas
    # -------------------------
    page.goto("https://www.99freelas.com.br/projects?order=mais-recentes&categoria=web-mobile-e-software")
    soup = BeautifulSoup(page.content(), 'html.parser')

    for a in soup.select('a[href^="/project/"]'):
        titulo = a.get_text(strip=True)
        if titulo:
            titles.append(titulo)

    # remove possíveis duplicados iniciais
    titles = list(dict.fromkeys(titles))

    # -------------------------
    # Workana
    # -------------------------
    page.goto("https://www.workana.com/en/jobs?category=it-programming&language=pt")            
    soup = BeautifulSoup(page.content(), 'html.parser')                                         
                                                                                                
    for item in soup.select("h2.project-title a"):                                              
        titulo = item.get("title")                                                              
        if titulo:                                                                              
            titles.append(titulo)                                                               
                                                                                                
    browser.close()                                                                             




                                                        

# -------------------------
# Gerar links corretamente
# -------------------------
jobs_with_links = []

for title in titles:
    slug = transforma_link(title)
    link = f"https://www.workana.com/job/{slug}"
    jobs_with_links.append(link)


# -------------------------
# Inserir no banco
# -------------------------
for title, link in zip(titles, jobs_with_links):
    insere_titulo_link(title, link)




with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()

    page.goto("https://www.freelancer.com/jobs/software-development")

    # espera os cards carregarem (IMPORTANTE)
    page.wait_for_selector("a.JobSearchCard-primary-heading-link")

    soup = BeautifulSoup(page.content(), 'html.parser')

    for item in soup.select("a.JobSearchCard-primary-heading-link"):
        titulo = item.get_text(strip=True)
        if titulo:
            titles.append(titulo)
            print(titulo)

    browser.close()                                  



for title in titles:                                        
    slug = transforma_link(title)                           
    link = f"https://www.freelancer.com/projects/automation/{slug}"                                                       
    jobs_with_links.append(link)                            
                                                            
                                                            
# -------------------------                                 
# Inserir no banco                                          
# -------------------------                                 
for title, link in zip(titles, jobs_with_links):            
    insere_titulo_link(title, link)                         
                                                            

































