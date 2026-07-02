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
    # FUNÇÃO DESCRIÇÃO (USADA SÓ NO WORKANA)
    # -------------------------
    def descricao(descricao_vaga):
        page.goto(descricao_vaga)
        soup = BeautifulSoup(page.content(),'html.parser')
        descricao_tag = soup.find("div", class_="expander")
        return descricao_tag.get_text(strip=True) if descricao_tag else None

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

            desc = descricao(link)  # 👈 só aqui usa descrição

            jobs.append({
                "titulo": titulo,
                "link": link,
                "plataforma": "Workana",
                "descricao": desc
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

    # -------------------------
    # Guru.com
    # -------------------------
    page.goto("https://www.guru.com/d/jobs/c/programming-development/")
    page.wait_for_selector("h2.jobRecord__title")

    soup = BeautifulSoup(page.content(), 'html.parser')

    for h2 in soup.select("h2.jobRecord__title"):
        a = h2.find("a", href=True)
        titulo = h2.get_text(strip=True)

        if titulo and a:
            href = a["href"]
            link = href if href.startswith("http") else "https://www.guru.com" + href

            jobs.append({
                "titulo": titulo,
                "link": link,
                "plataforma": "Guru"
            })

    browser.close()

# -------------------------
# Inserir no banco
# -------------------------
#


for job in jobs:
    print(job)

    insere_titulo_link(
        job["titulo"],
        job["link"],
        job["plataforma"],
        job.get("descricao")
    )
