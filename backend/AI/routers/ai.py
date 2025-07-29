# In AI/routers/ai.py

from fastapi import APIRouter, Depends, HTTPException, status
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

@router.post("/chat", response_model=ai_schemas.ChatResponse)
async def chat_with_ai(
    chat_request: ai_schemas.ChatRequest,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Handles a chat request for a specific medicine, maintaining conversation history.
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
        # Corrected initial prompt format
        initial_prompt = f"You are a helpful and friendly medical assistant. Explain things simply and clearly. The user wants to ask questions about the medicine: {medicine.name}. Do not give medical advice, but provide helpful, factual information."
        history.append({'role': 'user', 'parts': [{'text': initial_prompt}]})
        history.append({'role': 'model', 'parts': [{'text': f"Of course! I can provide information about {medicine.name}. What would you like to know?"}]})

    convo = ai_services.start_chat_session(history)
    ai_response_text = ai_services.send_message_to_ai(convo, chat_request.prompt)

    # --- THE FIX IS HERE ---
    # Manually build the history list from the conversation object's properties
    updated_history_list = [
        {'role': part.role, 'parts': [{'text': p.text} for p in part.parts]}
        for part in convo.history
    ]
    
    if chat_history_db:
        chat_history_db.history = updated_history_list
    else:
        chat_history_db = ai_models.AIChatHistory(
            user_id=current_user.user_id,
            medicine_id=chat_request.medicine_id,
            history=updated_history_list
        )
        db.add(chat_history_db)
    
    db.commit()

    return ai_schemas.ChatResponse(response=ai_response_text)