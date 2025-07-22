# In app/api/v1/dependencies/auth.py

import os
from dotenv import load_dotenv
from fastapi import Depends, HTTPException, status
# 1. Import HTTPBearer and HTTPAuthorizationCredentials instead
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError, jwt
from pydantic import BaseModel
from typing import Optional

# Load environment variables from your .env file
load_dotenv()

print(f"--- SECRET KEY LOADED FROM .env: {os.getenv('SUPABASE_JWT_SECRET')} ---")

# --- Configuration ---
SECRET_KEY = os.getenv("SUPABASE_JWT_SECRET")
ALGORITHM = "HS256"

# 2. Create an instance of HTTPBearer
security_scheme = HTTPBearer()

class TokenData(BaseModel):
    user_id: Optional[str] = None

# 3. Update the function to use the new scheme
async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security_scheme)):
    """
    Dependency to decode and validate a Supabase JWT from a Bearer token.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    if SECRET_KEY is None:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="JWT Secret Key is not configured on the server."
        )

    # 4. The token is now inside the credentials object
    token = credentials.credentials

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM], audience="authenticated")
        user_id: str = payload.get("sub") # 'sub' is the standard claim for user ID in a JWT
        if user_id is None:
            raise credentials_exception
        token_data = TokenData(user_id=user_id)
    except JWTError as e:
        print(f"!!! JWT VALIDATION ERROR: {e} !!!")
        raise credentials_exception
    
    return token_data