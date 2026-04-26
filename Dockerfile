FROM python:3.13.13-trixie

 #Evita .pyc e melhora logs

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Instala Poetry
RUN pip install poetry

# Config: não criar virtualenv dentro do container
RUN poetry config virtualenvs.create false

WORKDIR  freelancer_crawler/src/freelancer_crawler

COPY pyproject.toml poetry.lock* ./

RUN poetry install  --no-interaction --no-ansi --no-root

COPY .  .

EXPOSE 8000

CMD ["uvicorn", "src.freelancer_crawler.main:app", "--host", "0.0.0.0", "--port", "8000"]
