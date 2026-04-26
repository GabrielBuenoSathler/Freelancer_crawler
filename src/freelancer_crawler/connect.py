import json
import datetime
from pydantic import BaseModel
from sqlalchemy import create_engine, text
from datetime import datetime
import os
from dotenv import load_dotenv
url ="http://127.0.0.1:8000/vagas_99freelas"

load_dotenv()
POSTGRES_PASS = os.getenv('POSTGRES_PASSWORD')
POSTGRES_USER = os.getenv ('POSTGRES_USER')
POSTGRES_DB   = os.getenv ('POSTGRES_DB')
from typing import Optional

engine = create_engine(f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASS}@localhost:5432/{POSTGRES_DB}")

def insere_titulo_link(title, link):
    with engine.connect() as conn:
        conn.execute(
            text("""
                INSERT INTO freelas (titulo, link)
                VALUES (:titulo, :link)
                ON CONFLICT (titulo) DO NOTHING
            """),
            {"titulo": title, "link": link}
        )
        conn.commit()



class Freela(BaseModel):
    id: Optional[int] = None
    titulo: str
    link : Optional[str] = None
    created_at: Optional[datetime] = None
    
def show_records():
    with engine.connect() as conn:
        result = conn.execute(text("SELECT * FROM freelas"))
        rows = result.mappings().all()
        freelas = [Freela(**row) for row in rows]
        json_data = json.dumps(
        [f.model_dump(mode="json") for f in freelas],
        ensure_ascii=False
        )
        #data = json.loads(json_data)

        #for item in data:
         #   print(item["titulo"])
        return json_data



