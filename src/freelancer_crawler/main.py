from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/vagas_workana")
async def vagas_workana():
    return {"message": "vagas workana"}

@app.get("/vagas_99freelas")
async def vagas_99freelas():
    return {"message: vagas 99"}



