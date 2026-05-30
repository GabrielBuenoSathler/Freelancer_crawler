import os
from fastapi import FastAPI, Depends,HTTPException
from connect import show_records, inserir_user_profile,vagas_por_plataforma, inserir_user,get_db ,get_skills,update_users,update_profile
from models import User_profile, UserCreate, Users, Token, VagaMatch
from fastapi.middleware.cors import CORSMiddleware
from security import get_password_hash, verify_password,create_access_token,get_current_user
from fastapi.security import OAuth2PasswordRequestForm
from connect import profile as db_profile

from extract import match_vagas
app = FastAPI()

_cors_extra = os.getenv("CORS_ORIGIN", "")
_origins = [_cors_extra] if _cors_extra else []

app.add_middleware(
    CORSMiddleware,
    allow_origins=_origins,
    allow_origin_regex=r"http://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)



@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/vagas_workana")
async def vagas_workana():
    return vagas_por_plataforma('Workana')

@app.get("/vagas_99freelas/{records}")
async def vagas_99freelas(records:int = 0):
    return show_records(records)


@app.post("/users/")
async def create_user(user: UserCreate):
    inserir_user(user.username, user.email, get_password_hash(user.password))
    return {"message": "user created"}


@app.delete("/users/id")
async def delete_users():
    pass

@app.put("/user/")
async def update_user(user: Users):
    update_users(user.id,user.username , user.email , user.password)
    return {"message": "usuario atualizado"}


@app.post('/user_profile/')
async def create_user_profile( user_profile : User_profile, 
    conn  = Depends(get_db),
    current_user: Users = Depends(get_current_user)
):
    print("ew")
    inserir_user_profile(
        current_user,  # id do usuário logado
        user_profile.username,
        user_profile.nivel,
        user_profile.localizacao,
        user_profile.idiomas,
        user_profile.skill
    )

    return {"message": "user_profile created"}


@app.put('/user_profile/')
async def update_user_profile(
    user_profile: User_profile,
    conn=Depends(get_db),
    current_user: Users = Depends(get_current_user),
):
    update_profile(
        current_user,  # id do usuário logado
        user_profile.username,
        user_profile.nivel,
        user_profile.localizacao,
        user_profile.idiomas,
        user_profile.skill,
    )

    return {"message": "user_profile update !"}


@app.post('/token', response_model=Token)
def login_for_acess_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    conn = Depends(get_db),
):
    row = conn.execute(
        "SELECT email, password FROM users WHERE email = %s",
        (form_data.username,)
    ).fetchone()
    
    if not row:
        raise HTTPException(status_code=401, detail='Incorrect email or password')

    if not verify_password(form_data.password, row["password"]):
        raise HTTPException(status_code=401, detail='Incorrect email or password')
    print(row["email"])
    access_token = create_access_token(data={"sub": row["email"]})
    print(access_token)
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/profile")
async def profile(
    current_user: int = Depends(get_current_user)
):
    return db_profile(current_user)


@app.get("/match_vagas", response_model=list[VagaMatch])
async def match(current_user: int = Depends(get_current_user)):
    skills = get_skills(current_user)
    if not skills:
        raise HTTPException(status_code=400, detail="User profile not found. Please create a profile first.")

    print(skills)
    return match_vagas(skills[0])
  
