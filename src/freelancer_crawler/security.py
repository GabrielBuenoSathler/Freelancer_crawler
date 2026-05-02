# ... outros imports
from jwt import encode
from pwdlib import PasswordHash

#... Outras constantes
ACCESS_TOKEN_EXPIRE_MINUTES = 30
pwd_context = PasswordHash.recommended() 

# ... outras funções

def get_password_hash(password: str):
    return pwd_context.hash(password) 


def verify_password(plain_password: str, hashed_password: str):
    return pwd_context.verify(plain_password, hashed_password)
