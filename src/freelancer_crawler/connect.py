import json
from pydantic import BaseModel
from sqlalchemy import create_engine, text
from datetime import datetime
import os
from dotenv import load_dotenv
from typing import Optional

# -------------------------
# ENV
# -------------------------
load_dotenv()

POSTGRES_PASSWORD = os.getenv('POSTGRES_PASSWORD')
POSTGRES_USER     = os.getenv('POSTGRES_USER')
POSTGRES_DB       = os.getenv('POSTGRES_DB')

# -------------------------
# DB CONNECTION
# -------------------------
engine = create_engine(
    f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@localhost:5432/{POSTGRES_DB}"
)

# -------------------------
# INSERT / UPDATE
# -------------------------
def insere_titulo_link(title, link, plataforma, descricao=None):
    with engine.begin() as conn:  # ✅ commit automático
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
                "descricao": descricao
            }
        )

# -------------------------
# MODEL
# -------------------------
class Freela(BaseModel):
    id: Optional[int] = None
    titulo: str
    link: Optional[str] = None
    created_at: Optional[datetime] = None
    plataforma: Optional[str] = None
    descricao: Optional[str] = None

# -------------------------
# LISTAR REGISTROS
# -------------------------
def show_records(itens):
    with engine.connect() as conn:
        result = conn.execute(text("SELECT * FROM freelas LIMIT :limit"), {"limit": itens})
        rows = result.mappings().all()

        freelas = [Freela(**row) for row in rows]

        return json.dumps(
            [f.model_dump(mode="json") for f in freelas],
            ensure_ascii=False
        )

# -------------------------
# FILTRAR POR PLATAFORMA
# -------------------------
def vagas_por_plataforma(plataforma):
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT * FROM freelas WHERE plataforma = :plataforma"),
            {"plataforma": plataforma}
        )
        rows = result.mappings().all()

        freelas = [Freela(**row) for row in rows]

        return json.dumps(
            [f.model_dump(mode="json") for f in freelas],
            ensure_ascii=False
        )
