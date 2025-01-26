from fastapi import FastAPI, APIRouter, HTTPException
from pydantic import BaseModel, EmailStr

app = FastAPI()
router = APIRouter()
users = {}


class User(BaseModel):
    email: EmailStr
    full_name: str


@router.post("/users/")
def create_user(user: User):
    if user.email in users:
        raise HTTPException(status_code=400, detail="User already exists")
    users[user.email] = {"full_name": user.full_name}
    return {"message": "User created successfully"}


@router.get("/users/{email}")
def get_user(email: str):
    if email not in users:
        raise HTTPException(status_code=404, detail="User not found")
    return {"email": email, "full_name": users[email]["full_name"]}


app.include_router(router)
