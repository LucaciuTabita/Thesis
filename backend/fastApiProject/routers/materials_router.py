from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from schemas import MaterialCreate, MaterialResponse
from services.materials_service import create_material
from utils.auth import get_current_user
from typing import List
from models import Materials

router = APIRouter()

@router.post("/materials", response_model=MaterialResponse)
def add_material(material: MaterialCreate, db: Session = Depends(get_db), user: dict = Depends(get_current_user)):
    if not user:
        raise HTTPException(status_code=401, detail='Authentication credentials were not provided')
    return create_material(db, material, user['id'])

@router.get("/materials", response_model=List[MaterialResponse])
def get_materials(db: Session = Depends(get_db), user: dict = Depends(get_current_user)):
    if not user:
        raise HTTPException(status_code=401, detail='Authentication credentials were not provided')
    materials = db.query(Materials).filter(Materials.user_id == user['id']).all()
    return materials
