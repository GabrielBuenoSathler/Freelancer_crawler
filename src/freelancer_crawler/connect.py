# Replace placeholders with your actual database credentials
# # Replace placeholders with your actual database credentials
from sqlalchemy import create_engine, text
engine = create_engine("postgresql+psycopg2://docker:docker@localhost:5432/FREELANCERS")

from sqlalchemy import text

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

        result = conn.execute(text("SELECT * FROM freelas"))
        for row in result:
            print(f"titulo:{row.titulo}")
