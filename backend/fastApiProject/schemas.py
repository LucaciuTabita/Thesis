from pydantic import BaseModel

class MaterialCreate(BaseModel):
    image: str
    details: str

class MaterialUpdate(BaseModel):
    details: str

class MaterialResponse(BaseModel):
    id: int
    user_id: int
    details: str
    file_path: str  # Reflect the file path

    class Config:
        from_attributes = True

class UpdatePasswordRequest(BaseModel):
    current_password: str
    new_password: str