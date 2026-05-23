import json
from models import Freela
from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv
import psycopg
from psycopg.rows import dict_row

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



def get_db():
    with psycopg.connect(
        f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@localhost:5432/{POSTGRES_DB}",
        row_factory=dict_row
    ) as conn:
        print("GETDB")
        yield conn


# -------------------------
# INSERT / UPDATE
# -------------------------
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
                "descricao": descricao
            }
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
                "password": password                                      
            }                                                           
        )
 #| username | nivel | localizacao | idiomas | skill 
def inserir_user_profile(user_id,username, nivel, localizacao, idiomas, skill):                          
    with engine.begin() as conn:                                      
        conn.execute(                                                 
            text("""                                                  
                INSERT INTO user_profile (user_id,username, nivel, localizacao, idiomas,skill)         
                VALUES (:user_id,:username, :nivel ,:localizacao, :idiomas, :skill)                 
                                                                      
            """),                                                     
            {                                     
                "user_id": user_id,
                "username": username,                                 
                "nivel": nivel,                                       
                "localizacao":localizacao,
                "idiomas": idiomas,
                "skill" : skill
            }                                                         
        )                                                             



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





def vagas_to_emb():                                              
    with engine.connect() as conn:                                                 
        result = conn.execute(                                                     
            text("SELECT titulo, descricao from freelas WHERE descricao IS NOT NULL "),          
                                              
        )                                                                          
    vagas = result.mappings().all()
    return vagas


def profile(user_id):                                                                                   
    with engine.connect() as conn:                                                                    
        result = conn.execute(                                                                        
            text("SELECT nivel , skill from user_profile  WHERE user_id = :user_id"), 
            {"user_id" : user_id}
        )                                                                                             
    profiles  = result.mappings().all()   
    return profiles                  
                        

def get_skills(user_id):                                                                             
    with engine.connect() as conn:                                                                
        result = conn.execute(                                                                    
            text("SELECT skill from user_profile  WHERE user_id = :user_id"),             
            {"user_id" : user_id}                                                                 
        )                                                                                         
    skill  = result.mappings().all()                                                           
    return skill                                                                  
                                                                                                
                                                                                                  













































































