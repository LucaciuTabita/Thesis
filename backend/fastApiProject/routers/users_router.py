from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from schemas import UpdatePasswordRequest
from utils.auth import get_current_user
from services.users_service import update_user_password, delete_user_account

router = APIRouter()

@router.put("/auth/update_password", status_code=200)
async def update_password(update_password_request: UpdatePasswordRequest, db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    try:
        update_user_password(update_password_request, db, current_user)
        return {"message": "Password updated successfully"}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except KeyError:
        raise HTTPException(status_code=404, detail="User not found")

@router.delete("/auth/delete_account", status_code=204)
async def delete_account(db: Session = Depends(get_db), current_user: dict = Depends(get_current_user)):
    try:
        delete_user_account(db, current_user)
        return
    except KeyError:
        raise HTTPException(status_code=404, detail="User not found")
