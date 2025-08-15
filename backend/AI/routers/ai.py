from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
import uuid
from deep_translator import GoogleTranslator
import langdetect

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

def translate_to_english(text: str) -> str:
    """
    Detects the language of the text and translates it to English if it's not already English.
    Returns the original text if translation fails or if it's already English.
    """
    # Avoid errors with empty or whitespace-only strings
    if not text or not text.strip():
        return text

    try:
        # Detect the language of the source text
        detected_lang = langdetect.detect(text)

        # Check if the detected language is not English
        if detected_lang != 'en':
            print(f"Detected language: {detected_lang}. Translating to English.")
            # Translate the text from the detected language to English
            translated_text = GoogleTranslator(source=detected_lang, target='en').translate(text)
            return translated_text
        else:
            # If it's already English, return the original text
            return text
    except Exception as e:
        print(f"An error occurred during translation: {e}")
        # Fallback to returning the original text in case of any API errors
        return text

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
        # If no history exists, return an empty history
        return ai_schemas.ChatHistoryResponse(history=[])
    
    return ai_schemas.ChatHistoryResponse(history=chat_history_db.history)

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
        # Create an initial prompt to give the AI context
        initial_prompt = f"You are a helpful and friendly medical assistant. Explain things simply and clearly. The user wants to ask questions about the medicine: {medicine.name}. Do not give medical advice, but provide helpful, factual information. Always respond in English."
        history.append({'role': 'user', 'content': initial_prompt})
        history.append({'role': 'assistant', 'content': f"Of course! I can provide information about {medicine.name}. What would you like to know?"})

    # 'convo' becomes a reference to the 'history' list
    convo = ai_services.start_chat_session(history)
    
    # The send_message_to_ai function appends the new user message and the AI response to the 'convo' list
    ai_response_text = ai_services.send_message_to_ai(convo, chat_request.prompt)
    
    # Translate the AI response to English if it's not already in English
    translated_response = translate_to_english(ai_response_text)

    # --- THE FIX IS HERE ---
    # The 'convo' variable IS the updated history. Assign it directly.
    updated_history_list = convo
    
    # Update the last assistant message in the history with the translated version
    if updated_history_list and updated_history_list[-1]['role'] == 'assistant':
        updated_history_list[-1]['content'] = translated_response
    
    if chat_history_db:
        # If history already exists, update it
        chat_history_db.history = updated_history_list
    else:
        # Otherwise, create a new history record
        chat_history_db = ai_models.AIChatHistory(
            user_id=current_user.user_id,
            medicine_id=chat_request.medicine_id,
            history=updated_history_list
        )
        db.add(chat_history_db)
    
    db.commit()

    return ai_schemas.ChatResponse(response=translated_response)

@router.post("/ocr-analyze", response_model=ai_schemas.OcrResponse)
def analyze_medicine_from_ocr(
    ocr_request: ai_schemas.OcrRequest,
    current_user: TokenData = Depends(get_current_user) # Secure the endpoint
):
    try:
        analysis_result = ai_services.analyze_ocr_text(ocr_request.text)

        # --- SOLUTION ---
        # Extract the nested analysis dictionary
        print(analysis_result)
        name = analysis_result['analysis']['product_name']
        description = analysis_result['analysis']['interpretation']
        analysis_data = analysis_result.get("analysis", {})

        # Translate name and description to English
        # translated_name = translate_to_english(name)
        # translated_description = translate_to_english(description)

        # Create a new dictionary that matches the OcrResponse schema
        # We use .get() to provide default values in case the keys are missing
        
        formatted_response = {
            "name": name,
            "description": description
        }

        # Return the correctly formatted dictionary
        return formatted_response
    except Exception as e:
        # Handle potential errors from the AI service (e.g., invalid JSON response)
        raise HTTPException(status_code=500, detail=f"AI analysis failed: {e}")