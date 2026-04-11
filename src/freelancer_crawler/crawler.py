from playwright.sync_api import sync_playwright
from bs4 import BeautifulSoup

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)  # importante testar com UI
    page = browser.new_page()
    page.goto("https://www.99freelas.com.br/projects?order=mais-recentes&categoria=web-mobile-e-software")
    html = page.content()
    browser.close()

page = str(html)
soup = BeautifulSoup(page, 'html.parser')
print(soup.find_all('a'))


