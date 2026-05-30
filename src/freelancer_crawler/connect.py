import json
import os

import psycopg
from dotenv import load_dotenv
from psycopg.rows import dict_row
from sqlalchemy import create_engine, text

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


def get_db():
    with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
        print("GETDB")
        yield conn


# ---------------------------------------------------------------------------
# INSERT / UPDATE
# ---------------------------------------------------------------------------
def insere_titulo_link(title, link, plataforma, descricao=None):
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


def inserir_user(username, email, password):
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
def inserir_user_profile(user_id, username, nivel, localizacao, idiomas, skill):
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


def update_users(user_id, username, email, password):
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
def show_records(itens):
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
def vagas_por_plataforma(plataforma):
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
def vagas_to_emb():
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT titulo, descricao FROM freelas WHERE descricao IS NOT NULL")
        )
        return result.mappings().all()


def profile(user_id):
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT nivel, skill FROM user_profile WHERE user_id = :user_id"),
            {"user_id": user_id},
        )
        return result.mappings().all()


def update_profile(user_id):
 with engine.begin() as conn:                                                
     conn.execute(                                                           
         text("""                                                            
             UPDATE user_profile                                                    
             SET  nivel = :nivel,
             localizacao =:localizacao , idiomas = idiomas: skill =:skill
             WHERE user_id = :user_id                                        
         """),                                                               
         {   
                "nivel"       : nivel,
                "localizacao" : localizacao,
                "idiomas" :     idiomas,
                "skill" :       skill
         },                                                                  
     )                                                                       

def get_skills(user_id):
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT skill FROM user_profile WHERE user_id = :user_id"),
            {"user_id": user_id},
        )
        return result.mappings().all()
