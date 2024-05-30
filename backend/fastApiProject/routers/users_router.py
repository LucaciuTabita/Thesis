from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from schemas import UpdatePasswordRequest
from utils.auth import get_current_user, bcrypt_context
from models import Users

router = APIRouter()

@router.put("/auth/update_password", status_code=200)
async def update_password(update_password_request: UpdatePasswordRequest, db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    user = db.query(Users).filter(Users.id == current_user['id']).first()
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")

    if not bcrypt_context.verify(update_password_request.current_password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Current password is incorrect")

    user.hashed_password = bcrypt_context.hash(update_password_request.new_password)
    db.commit()
    return {"message": "Password updated successfully"}

@router.delete("/auth/delete_account", status_code=204)
async def delete_account(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    user = db.query(Users).filter(Users.id == current_user['id']).first()
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")

    db.delete(user)
    db.commit()
    return
