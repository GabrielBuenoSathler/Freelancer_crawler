import json
import datetime
from pydantic import BaseModel
from sqlalchemy import create_engine, text
from datetime import datetime
from typing import Optional
engine = create_engine("postgresql+psycopg2://docker:docker@localhost:5432/FREELANCERS")
def teste(values):
    with engine.connect() as conn:
        conn.execute(
            text("""
                INSERT INTO freelas (titulo)
                VALUES (:titulo)
                ON CONFLICT (titulo) DO NOTHING
            """),
            [{"titulo": values}]
        )
        conn.commit()




class Freela(BaseModel):
    id: Optional[int] = None
    titulo: str
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



