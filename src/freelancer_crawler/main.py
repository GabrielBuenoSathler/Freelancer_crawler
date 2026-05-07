from fastapi import FastAPI
from connect import *
from pydantic import BaseModel

app = FastAPI()


class Users(BaseModel):
    username: str
    email: str
    password: str


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






























