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

class Users(BaseModel):                                        
    username: str                                              
    email: str                                                 
    password: str                                              

class User_profile(BaseModel):                                 
    username: str                                              
    nivel: str                                                 
    localizacao: str                                           
    idiomas : str                                              
    skill : str                                                
