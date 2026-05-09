from fastapi import FastAPI, Depends,HTTPException
from connect import show_records, inserir_user_profile,vagas_por_plataforma, inserir_user,get_db 
from models import User_profile, Users,Token
from fastapi.middleware.cors import CORSMiddleware
from security import get_password_hash, verify_password,create_access_token 
from fastapi.security import OAuth2PasswordRequestForm


app = FastAPI()



app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # Vite default
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
async def create_user(user: Users):
    inserir_user(user.username, user.email, get_password_hash(user.password))
    return {"message": "user created"}

@app.post('/user_profile/')
async def create_user_profile(user_profile: User_profile):
    inserir_user_profile(user_profile.username, user_profile.nivel, user_profile.localizacao,user_profile.idiomas,user_profile.skill)  

    return {"message": "user_profile create_user"}



@app.post('/token', response_model=Token)
def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    conn = Depends(get_db),
):
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT email, password
            FROM users
            WHERE email = %s
            """,
            (form_data.username,)
        )

        user = cur.fetchone()

    if not user:
        raise HTTPException(
            status_code=401,
            detail='Incorrect email or password'
        )

    if not verify_password(
        form_data.password,
        user["password"]
    ):
        raise HTTPException(
            status_code=401,
            detail='Incorrect email or password'
        )

    access_token = create_access_token(
        data={'sub': user["email"]}
    )

    return {
        'access_token': access_token,
        'token_type': 'bearer'
    }











