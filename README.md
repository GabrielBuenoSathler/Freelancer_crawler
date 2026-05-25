# Freelancer Crawler

A web scraper and REST API that collects freelance job listings from **99Freelas**, **Workana**, and **Freelancer.com**, stores them in PostgreSQL, and uses semantic embeddings to match jobs to a user's skill set.

---

## Features

- Scrapes job listings from 3 platforms using Playwright + BeautifulSoup
- Stores jobs in PostgreSQL (upsert on title conflict)
- REST API built with FastAPI
- JWT authentication (OAuth2 password flow)
- Semantic job matching via `sentence-transformers` (cosine similarity)
- Telegram bot integration
- React/Vite frontend
- Docker Compose for deployment

---

## Architecture

```
.
├── src/freelancer_crawler/
│   ├── main.py         # FastAPI app and route definitions
│   ├── crawler.py      # Playwright scraper (99Freelas, Workana, Freelancer)
│   ├── connect.py      # Database connection and queries (SQLAlchemy + psycopg)
│   ├── models.py       # Pydantic models
│   ├── security.py     # JWT token creation and password hashing
│   ├── extract.py      # Semantic embedding and job matching pipeline
│   └── bot.py          # Telegram bot
├── frontend/vagas-app/ # React + Vite frontend
├── docker-compose.yaml
├── Dockerfile
└── pyproject.toml
```

---

## Requirements

- Python 3.13+
- Poetry
- Docker + Docker Compose (for containerised setup)
- PostgreSQL 15+

---

## Setup

### 1. Clone and install dependencies

```bash
poetry install
```

### 2. Configure environment variables

Create a `.env` file in the project root:

```env
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_DB=
# Telegram bot token
TOKEN=<your-telegram-bot-token>
```

### 3. Start the database

```bash
docker compose up db -d
```

### 4. Run the API

```bash
cd src/freelancer_crawler
uvicorn main:app --reload
```

The API will be available at `http://localhost:8000`.

### 5. Run the crawler

The crawler is a standalone script. Run it to populate the database with current job listings:

```bash
cd src/freelancer_crawler
python crawler.py
```

> Playwright must have its browsers installed. Run `playwright install chromium` once before the first crawl.

---

## Docker (full stack)

```bash
docker compose up --build
```

This starts the FastAPI app on port `8000` and PostgreSQL on port `5432`.

---

## API Reference

### Public endpoints

| Method | Route | Description |
|--------|-------|-------------|
| `GET` | `/` | Health check |
| `GET` | `/vagas_workana` | List all Workana jobs |
| `GET` | `/vagas_99freelas/{records}` | List up to `records` jobs from 99Freelas |
| `POST` | `/users/` | Create a new user |
| `POST` | `/token` | Login and receive a JWT access token |

### Authenticated endpoints

All authenticated routes require the header `Authorization: Bearer <token>`.

| Method | Route | Description |
|--------|-------|-------------|
| `GET` | `/profile` | Get the current user's profile |
| `POST` | `/user_profile/` | Create a profile for the current user |
| `GET` | `/match_vagas` | Return the top 10 job matches ranked by skill similarity |

---

### Authentication flow

1. Create a user: `POST /users/`
2. Obtain a token: `POST /token` (form fields: `username` = email, `password`)
3. Pass the token in subsequent requests: `Authorization: Bearer <token>`

Tokens expire after **30 minutes**.

---

### Example requests

**Create a user**
```bash
curl -X POST http://localhost:8000/users/ \
  -H "Content-Type: application/json" \
  -d '{"username": "gabriel", "email": "gabriel@example.com", "password": "secret"}'
```

**Login**
```bash
curl -X POST http://localhost:8000/token \
  -d "username=gabriel@example.com&password=secret"
```

**Get matched jobs**
```bash
curl http://localhost:8000/match_vagas \
  -H "Authorization: Bearer <token>"
```

---

## Job Matching

The `/match_vagas` endpoint uses a semantic similarity pipeline:

1. Loads job descriptions from the database (Workana jobs include descriptions).
2. Generates sentence embeddings using [`all-MiniLM-L6-v2`](https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2).
3. Embeds the user's skill string from their profile.
4. Ranks all jobs by cosine similarity and returns the top 10.

Embeddings are cached in `vaga_embeddings.pkl` to avoid recomputation on every request.

---

## Telegram Bot

The bot exposes the following commands:

| Command | Description |
|---------|-------------|
| `/start` | Greet the user |
| `/echo` | Echo back any message |
| `/puxa_vagas` | Send the 10 most recent 99Freelas listings |

To run the bot:

```bash
cd src/freelancer_crawler
python bot.py
```

The `TOKEN` environment variable must be set to your Telegram bot token.

---

## Frontend

A React + Vite app lives in `frontend/vagas-app/`.

```bash
cd frontend/vagas-app
npm install
npm run dev
```

The dev server starts on `http://localhost:5173` and proxies API requests to `http://localhost:8000`.

---

## Database Schema

| Table | Key columns |
|-------|-------------|
| `freelas` | `id`, `titulo` (unique), `link`, `plataforma`, `descricao`, `created_at` |
| `users` | `id`, `username`, `email`, `password` (hashed) |
| `user_profile` | `user_id` (FK), `username`, `nivel`, `localizacao`, `idiomas`, `skill` |

---

## CI/CD

A GitHub Actions workflow is defined in `.github/workflows/deploy.yml`.
