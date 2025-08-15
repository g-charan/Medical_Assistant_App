# In AI/routers/files_ai.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
import uuid

# --- THE FIX IS HERE ---
# Import dependencies from the 'app' module, where they actually live
from app.core.database import SessionLocal
from app.api.v1.dependencies.auth import get_current_user, TokenData
from app.api.v1.models import file_models
from app.api.v1.schemas import file_schemas # Correct import path

# Import local modules from the 'AI' module
from AI.schemas import ai_schemas
from AI.services import ai_services

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/process-file", response_model=file_schemas.FileProcessResponse)
def process_file(
    file_data: file_schemas.FileProcessRequest,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Processes an uploaded file. Checks if the file has been seen before using its hash.
    If it's a new file, it extracts and saves the text content.
    """
    # 1. Check if a file with this hash already exists
    existing_file = db.query(file_models.File).filter(file_models.File.file_hash == file_data.file_hash).first()

    if existing_file:
        print(f"File with hash {file_data.file_hash} already exists. Returning cached text.")
        return file_schemas.FileProcessResponse(
            file_id=existing_file.file_id,
            extracted_text=existing_file.extracted_text
        )

    # 2. If it's a new file, download it from Supabase Storage
    try:
        file_content = ai_services.download_file_content(file_data.file_url)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to download file: {e}")

    # 3. Extract the text from the file content
    extracted_text = ai_services.extract_text_from_file(file_content, file_data.file_type)

    # 4. Create a new file record in the database with the hash and extracted text
    new_file = file_models.File(
        user_id=current_user.user_id,
        file_url=file_data.file_url,
        file_hash=file_data.file_hash,
        file_type=file_data.file_type,
        description=file_data.description,
        extracted_text=extracted_text
    )
    db.add(new_file)
    db.commit()
    db.refresh(new_file)

    return file_schemas.FileProcessResponse(
        file_id=new_file.file_id,
        extracted_text=new_file.extracted_text
    )


@router.post("/chat-with-file", response_model=ai_schemas.ChatResponse)
def chat_with_file(
    chat_request: file_schemas.FileChatRequest,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Allows a user to ask a question about a previously processed file.
    """
    # 1. Find the file record in our database
    file_record = db.query(file_models.File).filter(file_models.File.file_id == chat_request.file_id).first()

    if not file_record:
        raise HTTPException(status_code=404, detail="File not found.")
    
    # 2. Check that the user owns this file
    if file_record.user_id != uuid.UUID(current_user.user_id):
        raise HTTPException(status_code=403, detail="Not authorized to access this file.")

    # 3. Use the AI service to answer the question based on the stored text
    try:
        ai_response = ai_services.chat_about_document(
            document_text=file_record.extracted_text,
            prompt=chat_request.prompt
        )
        return ai_schemas.ChatResponse(response=ai_response)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI chat failed: {e}")