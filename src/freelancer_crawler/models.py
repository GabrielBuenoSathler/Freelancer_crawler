from pydantic import BaseModel 
from typing import Optional
from datetime import datetime

class Freela(BaseModel):                     
    id: Optional[int] = None                 
    titulo: str                              
    link: Optional[str] = None               
    created_at: Optional[datetime] = None    
    plataforma: Optional[str] = None         
    descricao: Optional[str] = None

class UserCreate(BaseModel):
    username: str
    email: str
    password: str

class Users(BaseModel):
    id : int
    username: str
    email: str
    password: str

class User_profile(BaseModel):                                 
    username: str                                              
    nivel: str                                                 
    localizacao: str                                           
    idiomas : str                                              
    skill : str

class Login(BaseModel):    
    username : str
    password : str


class Token(BaseModel):
    access_token: str
    token_type: str

class VagaMatch(BaseModel):
    titulo: str
    descricao: str
    plataforma: str
    link: str
    score: float
