# In AI/routers/ai.py

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
import uuid

# Import dependencies from the 'app' module
from app.core.database import SessionLocal
from app.api.v1.dependencies.auth import get_current_user, TokenData
from app.api.v1.models import medicine_models

# Import local modules from the 'AI' module
from AI.models import ai_models
from AI.schemas import ai_schemas
from AI.services import ai_services

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/chat/{medicine_id}", response_model=ai_schemas.ChatHistoryResponse)
def get_chat_history(
    medicine_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Retrieves the chat history for a specific medicine for the authenticated user.
    """
    chat_history_db = db.query(ai_models.AIChatHistory).filter(
        ai_models.AIChatHistory.user_id == current_user.user_id,
        ai_models.AIChatHistory.medicine_id == medicine_id
    ).first()

    if not chat_history_db:
        return ai_schemas.ChatHistoryResponse(history=[])
    
    return ai_schemas.ChatHistoryResponse(history=chat_history_db.history)

@router.post("/chat", response_model=ai_schemas.ChatResponse)
async def chat_with_ai(
    chat_request: ai_schemas.ChatRequest,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Handles a streaming chat request for a specific medicine.
    """
    medicine = db.query(medicine_models.Medicine).filter(medicine_models.Medicine.medicine_id == chat_request.medicine_id).first()
    if not medicine:
        raise HTTPException(status_code=404, detail="Medicine not found.")

    chat_history_db = db.query(ai_models.AIChatHistory).filter(
        ai_models.AIChatHistory.user_id == current_user.user_id,
        ai_models.AIChatHistory.medicine_id == chat_request.medicine_id
    ).first()

    history = []
    if chat_history_db:
        history = chat_history_db.history
    else:
        initial_prompt = f"You are a helpful and friendly medical assistant. Explain things simply and clearly. The user wants to ask questions about the medicine: {medicine.name}. Do not give medical advice, but provide helpful, factual information."
        history.append({'role': 'user', 'parts': [{'text': initial_prompt}]})
        history.append({'role': 'model', 'parts': [{'text': f"Of course! I can provide information about {medicine.name}. What would you like to know?"}]})

    convo = ai_services.start_chat_session(history)

    async def stream_generator():
        full_response = ""
        # This function is not implemented in the current ai_services.py, so this will fail
        # We need to decide if we are streaming or not. For now, let's use the non-streaming version.
        # for chunk in ai_services.send_message_to_ai_stream(convo, chat_request.prompt):
        #     full_response += chunk
        #     yield chunk
        
        # Using the non-streaming version for now
        full_response = ai_services.send_message_to_ai(convo, chat_request.prompt)
        yield full_response

        # After the stream is complete, save the full history
        updated_history_list = [
            {'role': part.role, 'parts': [{'text': p.text} for p in part.parts]}
            for part in convo.history
        ]
        
        if chat_history_db:
            chat_history_db.history = updated_history_list
        else:
            new_history_record = ai_models.AIChatHistory(
                user_id=current_user.user_id,
                medicine_id=chat_request.medicine_id,
                history=updated_history_list
            )
            db.add(new_history_record)
        
        db.commit()

    # If we decide to stream, we return StreamingResponse. For now, let's return a normal response.
    # return StreamingResponse(stream_generator(), media_type="text/plain")
    
    # For now, let's make the non-streaming version work correctly.
    ai_response_text = ai_services.send_message_to_ai(convo, chat_request.prompt)
    
    updated_history_list = [
        {'role': part.role, 'parts': [{'text': p.text} for p in part.parts]}
        for part in convo.history
    ]
    
    if chat_history_db:
        chat_history_db.history = updated_history_list
    else:
        new_history_record = ai_models.AIChatHistory(
            user_id=current_user.user_id,
            medicine_id=chat_request.medicine_id,
            history=updated_history_list
        )
        db.add(new_history_record)
    
    db.commit()
    
    return ai_schemas.ChatResponse(response=ai_response_text)


@router.post("/ocr-analyze", response_model=ai_schemas.OcrResponse)
def analyze_medicine_from_ocr(
    ocr_request: ai_schemas.OcrRequest,
    current_user: TokenData = Depends(get_current_user)
):
    """
    Receives raw OCR text and uses AI to extract the medicine name and description.
    """
    try:
        analysis_result = ai_services.analyze_ocr_text(ocr_request.text)
        return analysis_result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI analysis failed: {e}")