from sqlalchemy.orm import Session
from schemas import UpdatePasswordRequest
from utils.auth import bcrypt_context
from models import Users

def update_user_password(update_password_request: UpdatePasswordRequest, db: Session, current_user: dict):
    user = db.query(Users).filter(Users.id == current_user['id']).first()
    if user is None:
        raise KeyError("User not found")

    if not bcrypt_context.verify(update_password_request.current_password, user.hashed_password):
        raise ValueError("Current password is incorrect")

    user.hashed_password = bcrypt_context.hash(update_password_request.new_password)
    db.commit()

def delete_user_account(db: Session, current_user: dict):
    user = db.query(Users).filter(Users.id == current_user['id']).first()
    if user is None:
        raise KeyError("User not found")

    db.delete(user)
    db.commit()
