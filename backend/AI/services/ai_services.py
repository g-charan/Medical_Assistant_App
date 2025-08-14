# In AI/services/ai_services.py

import os
import json
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

generation_config = {
  "temperature": 0.2,
  "top_p": 1,
  "top_k": 1,
  "max_output_tokens": 2048,
  "response_mime_type": "application/json",
}

model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    generation_config=generation_config
)

def start_chat_session(history):
    convo = model.start_chat(history=history)
    return convo

def send_message_to_ai(convo, prompt):
    convo.send_message(prompt)
    return convo.last.text

def send_message_to_ai_stream(convo, prompt):
    response_stream = convo.send_message(prompt, stream=True)
    for chunk in response_stream:
        yield chunk.text

# --- CORRECTED OCR ANALYSIS FUNCTION ---
def analyze_ocr_text(text: str) -> dict:
    """
    Analyzes raw OCR text to extract medicine name and description.
    """
    prompt = f"""
    Analyze the following text extracted from a medicine package.
    Identify the primary trade name of the medicine and provide a brief, one-sentence description of its main use.
    Return the result as a JSON object with two keys: "name" and "description".

    Text to analyze:
    ---
    {text}
    ---
    """
    
    response = model.generate_content(prompt)
    
    # --- THE FIX IS HERE ---
    # Clean up the response text before parsing
    try:
        # 1. Strip leading/trailing whitespace and backticks
        cleaned_text = response.text.strip().strip("`").strip()
        # 2. Remove the "json" prefix if it exists
        if cleaned_text.startswith("json"):
            cleaned_text = cleaned_text[4:].strip()
            
        # 3. Parse the cleaned text
        return json.loads(cleaned_text)
    except json.JSONDecodeError:
        # If parsing fails, raise an error with the problematic text
        raise ValueError(f"AI returned a non-JSON response: {response.text}")