import os
import time
from sqlalchemy.orm import Session
from models import Materials
from schemas import MaterialCreate, MaterialUpdate
import base64
from routers.prediction_router import predict_image
from fastapi import UploadFile
import io
import logging

PHOTOS_DIR = 'photos'

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def save_file(file_data: bytes, user_id: int) -> str:
    if not os.path.exists(PHOTOS_DIR):
        os.makedirs(PHOTOS_DIR)
    file_name = f'{user_id}_{int(time.time())}.jpg'
    file_path = os.path.join(PHOTOS_DIR, file_name)
    with open(file_path, 'wb') as file:
        file.write(file_data)
    logger.info(f"File saved at {file_path}")
    return file_path

def create_material(db: Session, material: MaterialCreate, user_id: int):
    logger.info("Creating material...")
    try:
        file_data = base64.b64decode(material.image)  # Decode the base64 image data
        file_path = save_file(file_data, user_id)
        db_material = Materials(
            user_id=user_id,
            details=material.details,
            file_path=file_path
        )
        db.add(db_material)
        db.commit()
        db.refresh(db_material)
        logger.info("Material created successfully")
        return db_material
    except Exception as e:
        logger.error(f"Error in create_material: {e}")
        db.rollback()
        raise e


def update_material(db: Session, material: Materials, material_update: MaterialUpdate):
    material.details = material_update.details
    db.commit()
    db.refresh(material)
    return material


def delete_material(db: Session, material: Materials):
    db.delete(material)
    db.commit()