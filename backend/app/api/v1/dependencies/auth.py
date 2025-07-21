# In app/api/v1/dependencies/auth.py

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from pydantic import BaseModel
from typing import Optional  # Import Optional

# --- Configuration ---
# Paste the JWT Secret you copied from your Supabase Project API settings
SECRET_KEY = "TF1kFuFhYfvdozPf4mLnrlQESoy7LzhxrlQKNRMAY4il/OAQXVabn38iRimmC8QghK8MN9H3gdwSyhYGnlGKew=="
ALGORITHM = "HS256"

# This scheme will look for a token in the 'Authorization: Bearer <token>' header
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

class TokenData(BaseModel):
    # Use the older, compatible syntax for optional types
    user_id: Optional[str] = None

async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub") # 'sub' is the standard claim for user ID
        if user_id is None:
            raise credentials_exception
        token_data = TokenData(user_id=user_id)
    except JWTError:
        raise credentials_exception
    return token_data