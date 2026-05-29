from datetime import datetime,timedelta
from pwdlib import PasswordHash
from http import HTTPStatus
from zoneinfo import ZoneInfo
from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from jwt import decode, encode,InvalidTokenError
from connect import get_db 

import os

SECRET_KEY = os.getenv('SECRET_KEY')
if not SECRET_KEY:
    raise ValueError('SECRET_KEY environment variable is required for production security')
ALGORITHM = 'HS256'
ACCESS_TOKEN_EXPIRE_MINUTES = 30
pwd_context = PasswordHash.recommended()


def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.now(tz=ZoneInfo('UTC')) + timedelta(
        minutes=ACCESS_TOKEN_EXPIRE_MINUTES
    )
    to_encode.update({'exp': expire})
    encoded_jwt = encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


def get_password_hash(password: str):
    return pwd_context.hash(password) 


def verify_password(plain_password: str, hashed_password: str):
    return pwd_context.verify(plain_password, hashed_password)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl='token')



# security.py - get_current_user
def get_current_user(
    conn = Depends(get_db),
    token: str = Depends(oauth2_scheme),
):

    if token is None:
        raise HTTPException(
            status_code=401,
            detail="Token não enviado"
        )

    credentials_exception = HTTPException(
        status_code=HTTPStatus.UNAUTHORIZED,
        detail='Could not validate credentials',
        headers={'WWW-Authenticate': 'Bearer'},
    )
    try:
        payload = decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        subject_email = payload.get("sub")
        if subject_email is None:
            raise credentials_exception
    except InvalidTokenError:
        raise credentials_exception

    # psycopg3: execute direto na conexão, sem .cursor() como context manager
    row = conn.execute(
        "SELECT id, email FROM users WHERE email = %s",
        (subject_email,)
    ).fetchone()

    if row is None:
        raise credentials_exception

    return row["id"]

























































































































