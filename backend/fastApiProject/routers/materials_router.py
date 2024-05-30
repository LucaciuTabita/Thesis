from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from database import get_db
from schemas import MaterialCreate, MaterialResponse, MaterialUpdate
from services.materials_service import create_material, update_material, delete_material
from utils.auth import get_current_user
from typing import List
from models import Materials
from routers.prediction_router import predict_image
import base64
import io
import logging

router = APIRouter()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@router.post("/materials", response_model=MaterialResponse)
def add_material(material: MaterialCreate, db: Session = Depends(get_db), user: dict = Depends(get_current_user)):
    logger.info("Adding a new material...")
    if not user:
        raise HTTPException(status_code=401, detail='Authentication credentials were not provided')

    logger.info(f"User ID: {user['id']}")
    logger.info(f"Material Details: {material.details}")

    try:
        return create_material(db, material, user['id'])
    except Exception as e:
        logger.error(f"Error adding material: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/materials", response_model=List[MaterialResponse])
def get_materials(db: Session = Depends(get_db), user: dict = Depends(get_current_user)):
    if not user:
        raise HTTPException(status_code=401, detail='Authentication credentials were not provided')
    materials = db.query(Materials).filter(Materials.user_id == user['id']).all()
    return materials


@router.get("/materials/{material_id}", response_model=MaterialResponse)
def get_material(material_id: int, db: Session = Depends(get_db), user: dict = Depends(get_current_user)):
    material = db.query(Materials).filter(Materials.id == material_id, Materials.user_id == user['id']).first()
    if material is None:
        raise HTTPException(status_code=404, detail='Material not found')
    return material

@router.put("/materials/{material_id}", response_model=MaterialResponse)
def modify_material(material_id: int, material_update: MaterialUpdate, db: Session = Depends(get_db), user: dict = Depends(get_current_user)):
    material = db.query(Materials).filter(Materials.id == material_id, Materials.user_id == user['id']).first()
    if material is None:
        raise HTTPException(status_code=404, detail='Material not found')
    return update_material(db, material, material_update)

@router.delete("/materials/{material_id}", status_code=204)
def remove_material(material_id: int, db: Session = Depends(get_db), user: dict = Depends(get_current_user)):
    material = db.query(Materials).filter(Materials.id == material_id, Materials.user_id == user['id']).first()
    if material is None:
        raise HTTPException(status_code=404, detail='Material not found')
    delete_material(db, material)
    return