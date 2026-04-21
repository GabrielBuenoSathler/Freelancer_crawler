from fastapi import FastAPI
from connect import *
app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/vagas_workana")
async def vagas_workana():
    return {"message": "vagas workana"}

@app.get("/vagas_99freelas")
async def vagas_99freelas():
    return show_records()

