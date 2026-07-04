import json
import os
from collections.abc import Iterator, Sequence

import psycopg
from dotenv import load_dotenv
from psycopg.rows import DictRow, dict_row
from sqlalchemy import RowMapping, create_engine, text

from models import Freela

# ---------------------------------------------------------------------------
# ENV
# ---------------------------------------------------------------------------
load_dotenv()

POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_DB = os.getenv("POSTGRES_DB")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")

_CREDENTIALS = f"{POSTGRES_USER}:{POSTGRES_PASSWORD}@{DB_HOST}:{DB_PORT}/{POSTGRES_DB}"
DATABASE_URL = f"postgresql://{_CREDENTIALS}"          # used by psycopg.connect
SQLALCHEMY_URL = f"postgresql+psycopg://{_CREDENTIALS}"  # used by SQLAlchemy engine

# ---------------------------------------------------------------------------
# DB CONNECTION
# ---------------------------------------------------------------------------
engine = create_engine(SQLALCHEMY_URL)


def get_db() -> Iterator[psycopg.Connection[DictRow]]:
    with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
        print("GETDB")
        yield conn


# ---------------------------------------------------------------------------
# INSERT / UPDATE
# ---------------------------------------------------------------------------
def insere_titulo_link(title: str, link: str, plataforma: str, descricao: str | None = None) -> None:
    with engine.begin() as conn:
        conn.execute(
            text("""
                INSERT INTO freelas (titulo, link, plataforma, descricao)
                VALUES (:titulo, :link, :plataforma, :descricao)
                ON CONFLICT (titulo) DO UPDATE SET
                    link = EXCLUDED.link,
                    plataforma = EXCLUDED.plataforma,
                    descricao = EXCLUDED.descricao
            """),
            {
                "titulo": title,
                "link": link,
                "plataforma": plataforma,
                "descricao": descricao,
            },
        )


def inserir_user(username: str, email: str, password: str) -> None:
    with engine.begin() as conn:
        conn.execute(
            text("""
                INSERT INTO users (username, email, password)
                VALUES (:username, :email, :password)
            """),
            {
                "username": username,
                "email": email,
                "password": password,
            },
        )


# user_profile columns: user_id | username | nivel | localizacao | idiomas | skill
def inserir_user_profile(
    user_id: int,
    username: str,
    nivel: str,
    localizacao: str,
    idiomas: str,
    skill: str,
) -> None:
    with engine.begin() as conn:
        conn.execute(
            text("""
                INSERT INTO user_profile (user_id, username, nivel, localizacao, idiomas, skill)
                VALUES (:user_id, :username, :nivel, :localizacao, :idiomas, :skill)
            """),
            {
                "user_id": user_id,
                "username": username,
                "nivel": nivel,
                "localizacao": localizacao,
                "idiomas": idiomas,
                "skill": skill,
            },
        )


def update_users(
    user_id: int,
    username: str | None,
    email: str | None,
    password: str | None,
) -> None:
    fields = {
        "username": username,
        "email": email,
        "password": password,
    }
    # ignora campos vazios/None: só atualiza o que foi informado
    updates = {key: value for key, value in fields.items() if value}

    if not updates:
        return

    set_clause = ", ".join(f"{key} = :{key}" for key in updates)
    params = {**updates, "user_id": user_id}

    with engine.begin() as conn:
        conn.execute(
            text(f"""
                UPDATE users
                SET {set_clause}
                WHERE user_id = :user_id
            """),
            params,
        )


# ---------------------------------------------------------------------------
# LISTAR REGISTROS
# ---------------------------------------------------------------------------
def show_records(itens: int) -> str:
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT * FROM freelas LIMIT :limit"),
            {"limit": itens},
        )
        rows = result.mappings().all()

    freelas = [Freela(**row) for row in rows]
    return json.dumps(
        [f.model_dump(mode="json") for f in freelas],
        ensure_ascii=False,
    )
# ---------------------------------------------------------------------------
# FILTRAR POR PLATAFORMA
# ---------------------------------------------------------------------------
def vagas_por_plataforma(plataforma: str) -> str:
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT * FROM freelas WHERE plataforma = :plataforma"),
            {"plataforma": plataforma},
        )
        rows = result.mappings().all()

    freelas = [Freela(**row) for row in rows]
    return json.dumps(
        [f.model_dump(mode="json") for f in freelas],
        ensure_ascii=False,
    )


# ---------------------------------------------------------------------------
# EMBEDDINGS / MATCHING
# ---------------------------------------------------------------------------
def vagas_to_emb() -> Sequence[RowMapping]:
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT titulo, descricao FROM freelas WHERE descricao IS NOT NULL")
        )
        return result.mappings().all()


def profile(user_id: int) -> Sequence[RowMapping]:
    with engine.connect() as conn:
        result = conn.execute(
            text("""
                SELECT username, nivel, localizacao, idiomas, skill
                FROM user_profile
                WHERE user_id = :user_id
            """),
            {"user_id": user_id},
        )
        return result.mappings().all()


def update_profile(
    user_id: int,
    username: str,
    nivel: str,
    localizacao: str,
    idiomas: str,
    skill: str,
) -> None:
    with engine.begin() as conn:
        conn.execute(
            text("""
                UPDATE user_profile
                SET username = :username,
                    nivel = :nivel,
                    localizacao = :localizacao,
                    idiomas = :idiomas,
                    skill = :skill
                WHERE user_id = :user_id
            """),
            {
                "user_id": user_id,
                "username": username,
                "nivel": nivel,
                "localizacao": localizacao,
                "idiomas": idiomas,
                "skill": skill,
            },
        )

def get_skills(user_id: int) -> Sequence[RowMapping]:
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT skill FROM user_profile WHERE user_id = :user_id"),
            {"user_id": user_id},
        )
        return result.mappings().all()
