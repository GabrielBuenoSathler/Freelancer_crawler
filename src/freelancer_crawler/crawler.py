from playwright.sync_api import sync_playwright
from bs4 import BeautifulSoup
import re
from connect import teste  
with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)  # importante testar com UI
    page = browser.new_page()
    page.goto("https://www.99freelas.com.br/projects?order=mais-recentes&categoria=web-mobile-e-software")
    html = page.content()
    browser.close()

page = str(html)
soup = BeautifulSoup(page, 'html.parser')

titles = []

for a in soup.find_all("a", href=True):
    if a["href"].startswith("/project/"):
        titles.append(a.get_text(strip=True))

del titles[0:2]

print(titles)
with sync_playwright() as p:                                                                                                                                                       
   browser = p.chromium.launch(headless=False)  # importante testar com UI                                     
   page = browser.new_page()                                                                                   
   page.goto("https://www.workana.com/en/jobs?category=it-programming&language=pt")      
   html = page.content()                                                                                       
   browser.close()                      

page_work = str (html)
soup = BeautifulSoup(page_work,'html.parser')

# Em vez de buscar por "title", buscamos pela classe que contém o título
for item in soup.find_all("h2", class_="project-title"):
    # Usamos regex apenas no pedaço de HTML desse item específico
    texto_item = str(item)
    match = re.search(r'title="([^"]+)"', texto_item)
    if match:
        titles.append(match.group(1))

        
for x in titles:
    teste(x)
