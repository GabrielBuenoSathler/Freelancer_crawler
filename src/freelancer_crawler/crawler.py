from playwright.sync_api import sync_playwright
from bs4 import BeautifulSoup
import re
import unicodedata
from connect import insere_titulo_link

# Lista única para tudo
jobs = []

def transforma_link(text):
    text = unicodedata.normalize('NFKD', text)
    text = text.encode('ascii', 'ignore').decode('ascii')
    text = text.lower()
    text = re.sub(r'[^a-z0-9\s-]', '', text)
    text = re.sub(r'\s+', '-', text)
    return text.rstrip('-')

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
            link = "https://www.99freelas.com.br" + a["href"]

            jobs.append({
                "titulo": titulo,
                "link": link,
                "plataforma": "99Freelas"
            })

    # -------------------------
    # Workana
    # -------------------------
    page.goto("https://www.workana.com/en/jobs?category=it-programming&language=pt")
    soup = BeautifulSoup(page.content(), 'html.parser')

    for item in soup.select("h2.project-title a span[title]"):
        titulo = item.get("title")

        if titulo:
            slug = transforma_link(titulo)
            link = f"https://www.workana.com/job/{slug}"

            jobs.append({
                "titulo": titulo,
                "link": link,
                "plataforma": "Workana"
            })

    # -------------------------
    # Freelancer
    # -------------------------
    page.goto("https://www.freelancer.com/jobs/software-development")
    page.wait_for_selector("a.JobSearchCard-primary-heading-link")

    soup = BeautifulSoup(page.content(), 'html.parser')

    for item in soup.select("a.JobSearchCard-primary-heading-link"):
        titulo = item.get_text(strip=True)

        if titulo:
            slug = transforma_link(titulo)
            link = f"https://www.freelancer.com/projects/automation/{slug}"

            jobs.append({
                "titulo": titulo,
                "link": link,
                "plataforma": "Freelancer"
            })

    browser.close()

# -------------------------
# Inserir no banco
# -------------------------
for job in jobs:
    insere_titulo_link(
        job["titulo"],
        job["link"],
        job["plataforma"]
    )
