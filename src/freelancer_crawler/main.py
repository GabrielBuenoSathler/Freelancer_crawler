from fastapi import FastAPI
from connect import *

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/vagas_workana")
async def vagas_workana():
    return vagas_por_plataforma('Workana')

@app.get("/vagas_99freelas/{records}")
async def vagas_99freelas(records:int = 0):
    return show_records(records)



