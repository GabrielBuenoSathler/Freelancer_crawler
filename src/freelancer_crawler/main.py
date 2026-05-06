from fastapi import FastAPI
from connect import *
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # Vite default
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)



class Users(BaseModel):
    username: str
    email: str
    password: str
# | username | nivel | localizacao | idiomas | skill 
class User_profile(BaseModel):         
    username: str
    nivel: str
    localizacao: str 
    idiomas : str 
    skill : str 

@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/vagas_workana")
async def vagas_workana():
    return vagas_por_plataforma('Workana')


@app.get("/vagas_99freelas/{records}")
async def vagas_99freelas(records: int = 0):
    return show_records(records)


@app.post("/users/")
async def create_user(user: Users):
    inserir_user(user.username, user.email, user.password)
    return {"message": "user created"}

@app.post('/user_profile/')
async def create_user_profile(user_profile: User_profile):
    inserir_user_profile(user_profile.username, user_profile.nivel, user_profile.localizacao,user_profile.idiomas,user_profile.skill)  

    return {"message": "user_profile create_user"}




























