from pydantic import BaseModel

class MaterialCreate(BaseModel):
    image: str
    details: str

class MaterialResponse(BaseModel):
    id: int
    user_id: int
    details: str
    file_path: str  # Reflect the file path

    class Config:
        from_attributes = True
