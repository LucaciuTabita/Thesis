import os
import time
from sqlalchemy.orm import Session
from models import Materials
from schemas import MaterialCreate
import base64

PHOTOS_DIR = 'photos'

def save_file(file_data: bytes, user_id: int) -> str:
    if not os.path.exists(PHOTOS_DIR):
        os.makedirs(PHOTOS_DIR)
    file_name = f'{user_id}_{int(time.time())}.jpg'
    file_path = os.path.join(PHOTOS_DIR, file_name)
    with open(file_path, 'wb') as file:
        file.write(file_data)
    return file_path

def create_material(db: Session, material: MaterialCreate, user_id: int):
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
    return db_material
