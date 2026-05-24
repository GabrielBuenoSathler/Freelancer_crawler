# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Freelancer Crawler** is a full-stack job matching platform that scrapes freelance listings from 3 platforms (99Freelas, Workana, Freelancer.com), stores them in PostgreSQL, and uses semantic embeddings to match jobs to user skill sets.

**Stack**: Python 3.13+ (FastAPI) + React 19 (Vite) + PostgreSQL + Docker

---

## Architecture Overview

### Backend (Python/FastAPI)
Located in `src/freelancer_crawler/`, the backend is organized around key responsibilities:

- **`main.py`**: FastAPI application with route definitions. Routes are split into:
  - Public: `/`, `/vagas_workana`, `/vagas_99freelas/{records}`, `/users/` (signup), `/token` (login)
  - Authenticated (JWT): `/profile`, `/user_profile/`, `/match_vagas`
  - CORS is configured to allow localhost and configurable origins via `CORS_ORIGIN` env var

- **`connect.py`**: Database layer using SQLAlchemy + psycopg. Handles:
  - Connection pooling (`get_db` dependency)
  - CRUD for users, user profiles, job listings
  - Upsert logic for jobs (conflict on `titulo`)
  - Query functions: `show_records()`, `vagas_por_plataforma()`, `profile()`, `get_skills()`

- **`crawler.py`**: Web scraper using Playwright + BeautifulSoup. Scrapes:
  - 99Freelas, Workana, Freelancer.com
  - Extracts title, link, platform, description
  - Inserts/upserts into `freelas` table

- **`extract.py`**: Semantic job matching pipeline:
  - Uses `sentence-transformers` (`all-MiniLM-L6-v2` model)
  - Generates embeddings for job descriptions (cached in `vaga_embeddings.pkl`)
  - Ranks jobs by cosine similarity to user skills
  - Returns top 10 matches

- **`security.py`**: Authentication:
  - JWT token creation/validation (30-min expiry)
  - Argon2 password hashing
  - `get_current_user()` dependency for protected routes

- **`models.py`**: Pydantic request/response schemas (`User`, `User_profile`, `Token`)

- **`bot.py`**: Telegram bot with commands: `/start`, `/echo`, `/puxa_vagas`

### Database Schema
Three main tables:
- `freelas`: job listings (id, titulo, link, plataforma, descricao, created_at)
- `users`: accounts (id, username, email, password_hash)
- `user_profile`: user metadata (user_id FK, username, nivel, localizacao, idiomas, skill)

### Frontend (React/Vite)
Located in `frontend/vagas-app/`, organized by routes:

- **`router.tsx`**: React Router configuration with routes:
  - `/` → Home
  - `/register` → User signup
  - `/register-skill` → Skill profile creation (authenticated)
  - `/login` → Login
  - `/vagas` → Job matching results (authenticated)

- **`pages/`**: Page components for each route
- **`src/index.css`**: Global styles

Uses **Vite** for fast dev server and builds. Dev server at `localhost:5173` proxies API calls to `localhost:8000`.

---

## Common Development Tasks

### Setup
```bash
# Backend dependencies
poetry install

# Frontend dependencies (from frontend/vagas-app/)
npm install

# Install Playwright browsers (needed for crawler)
playwright install chromium
```

### Running Services

**Backend (FastAPI)**
```bash
# From src/freelancer_crawler/
uvicorn main:app --reload
# API: http://localhost:8000
# Docs: http://localhost:8000/docs
```

**Frontend (Vite)**
```bash
# From frontend/vagas-app/
npm run dev
# Dev server: http://localhost:5173
```

**Database (Docker)**
```bash
# Start PostgreSQL
docker compose up db -d

# Full stack (API + frontend + DB)
docker compose up --build
```

**Crawler (one-off)**
```bash
# From src/freelancer_crawler/
python crawler.py
```

**Telegram Bot**
```bash
# Set TOKEN env var first
TOKEN=<bot-token> python bot.py
```

### Building & Linting

**Frontend**
```bash
cd frontend/vagas-app
npm run build   # TypeScript compile + Vite bundle
npm run lint    # ESLint
```

**Backend**
```bash
ruff check src/freelancer_crawler/  # Linting with Ruff
```

### Testing
```bash
# Run pytest (config in pyproject.toml ignores postgres-data)
pytest

# Run specific test
pytest tests/test_um.py
```

---

## Key Implementation Details

### Authentication Flow
1. User signs up: `POST /users/` with username, email, password
2. User logs in: `POST /token` with email + password → JWT token
3. Protected routes require `Authorization: Bearer <token>` header
4. Tokens expire after 30 minutes

### Job Matching Pipeline
1. Frontend user creates skill profile → stored in `user_profile.skill`
2. Frontend calls `GET /match_vagas` with JWT token
3. Backend extracts user skills, generates embeddings
4. Cosine similarity computed against all job embeddings
5. Top 10 matches returned (includes job title, link, platform, similarity score)

### Environment Variables
Create `.env` in project root:
```env
POSTGRES_USER=docker
POSTGRES_PASSWORD=docker
POSTGRES_DB=FREELANCERS
CORS_ORIGIN=http://example.com  # Optional, for production CORS
TOKEN=<telegram-bot-token>       # For bot.py
```

### Database Connection
- Uses `psycopg` (psycopg3) for async-compatible connections
- Connection pooling via SQLAlchemy in `connect.py`
- Password stored with Argon2 hashing

### Embedding Cache
- `vaga_embeddings.pkl` caches computed embeddings to avoid recomputation
- Regenerates if job descriptions change
- Located in `src/freelancer_crawler/`

---

## Dependencies & Tools

**Python**
- FastAPI 0.136+: Web framework
- SQLAlchemy 2.0+: ORM
- psycopg/psycopg2: PostgreSQL drivers
- Playwright 1.58+: Browser automation
- BeautifulSoup4: HTML parsing
- sentence-transformers 5.4+: Semantic embeddings
- PyJWT + pwdlib: Authentication
- python-telegram-bot: Telegram integration
- Ruff: Linting/formatting
- pytest: Testing

**JavaScript/TypeScript**
- React 19: UI framework
- React Router 7.15: Client-side routing
- Vite 8: Build tool
- TypeScript 6.0: Type checking
- ESLint: Code quality

---

## Notes for Future Work

- Tests are minimal (one test file). Add pytest fixtures for database mocking before expanding test coverage.
- Frontend has no API client abstraction—consider centralizing fetch calls to a service layer for maintainability.
- Embedding computation is synchronous; consider background job queue for large-scale crawls.
- JWT refresh tokens not yet implemented—30-min expiry requires re-login.
