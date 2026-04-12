from playwright.sync_api import sync_playwright
from bs4 import BeautifulSoup
import re
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
                                                                    
