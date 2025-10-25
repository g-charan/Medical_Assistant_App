from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
import uuid

# Import dependencies from the 'app' module
from app.core.database import SessionLocal
from app.api.v1.dependencies.auth import get_current_user, TokenData

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

@router.get("/", response_model=ai_schemas.ChatHistoryResponse)
def get_general_chat_history(
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Retrieves the general chat history for the authenticated user.
    """
    chat_history_db = db.query(ai_models.GeneralChatHistory).filter(
        ai_models.GeneralChatHistory.user_id == current_user.user_id
    ).first()

    if not chat_history_db:
        # Return an empty history if no conversation has started
        return ai_schemas.ChatHistoryResponse(history=[])
    
    return ai_schemas.ChatHistoryResponse(history=chat_history_db.history)

@router.post("/", response_model=ai_schemas.ChatResponse)
async def chat_with_ai_general(
    chat_request: ai_schemas.GeneralChatRequest,
    db: Session = Depends(get_db),
    current_user: TokenData = Depends(get_current_user)
):
    """
    Handles a chat request for the general-purpose medical AI.
    """
    
    # 1. Find the user's existing chat history
    chat_history_db = db.query(ai_models.GeneralChatHistory).filter(
        ai_models.GeneralChatHistory.user_id == current_user.user_id
    ).first()

    history = []
    if chat_history_db:
        history = chat_history_db.history
    else:
        # 2. If no history, create the initial prompt
        initial_prompt = (
            "You are Medi Qube, a helpful and friendly medical AI assistant. "
            "Explain things simply and clearly. Users will ask you general "
            "questions about medicines, diseases, and health. Do not give "
            "personal medical advice, but provide helpful, factual information."
        )
        history.append({'role': 'user', 'parts': [{'text': initial_prompt}]})
        history.append({'role': 'model', 'parts': [{'text': "Of course! I'm here to help. What would you like to know?"}]})

    # 3. Start the chat session with the loaded history
    convo = ai_services.start_chat_session(history)

    # 4. Send the new prompt to the AI
    ai_response_text = ai_services.send_message_to_ai(convo, chat_request.prompt)
    
    # 5. Get the complete, updated history from the AI service
    updated_history_list = [
        {'role': part.role, 'parts': [{'text': p.text} for p in part.parts]}
        for part in convo.history
    ]
    
    # 6. Save the updated history back to the database
    if chat_history_db:
        # Update existing record
        chat_history_db.history = updated_history_list
    else:
        # Create a new record
        new_history_record = ai_models.GeneralChatHistory(
            user_id=current_user.user_id,
            history=updated_history_list
        )
        db.add(new_history_record)
    
    db.commit()
    
    # 7. Return just the AI's last response
    return ai_schemas.ChatResponse(response=ai_response_text)