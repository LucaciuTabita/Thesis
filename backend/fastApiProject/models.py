from database import Base
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

class Users(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    username = Column(String, unique=True)
    hashed_password = Column(String)
    materials = relationship("Materials", back_populates="user")

class Materials(Base):
    __tablename__ = 'materials'

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    details = Column(String)
    file_path = Column(String)  # Store file path instead of binary data

    user = relationship("Users", back_populates="materials")
