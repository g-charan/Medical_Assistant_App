# In AI/services/ai_services.py
import os
import json
import httpx
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()

# Ensure your GOOGLE_API_KEY is in the .env file
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

# Configuration for the OCR analysis (JSON output)
json_generation_config = {
  "temperature": 0.2,
  "top_p": 1,
  "top_k": 1,
  "max_output_tokens": 2048,
  "response_mime_type": "application/json",
}

# Configuration for the chat (text output)
chat_generation_config = {
  "temperature": 0.9,
  "top_p": 1,
  "top_k": 1,
  "max_output_tokens": 2048,
}

# Initialize the model for OCR/JSON tasks
json_model = genai.GenerativeModel(
    model_name="gemini-2.5-flash",
    generation_config=json_generation_config
)

# Initialize the model for chat tasks
chat_model = genai.GenerativeModel(
    model_name="gemini-2.5-flash",
    generation_config=chat_generation_config
)


def analyze_ocr_text(text: str) -> dict:
    prompt = f"""
    Analyze the following text from a medicine package.
    Identify the primary trade name and a brief, one-sentence description of its main use.
    Return ONLY a raw JSON object with two keys: "name" and "description".

    Text to analyze:
    ---
    {text}
    ---
    """
    try:
        response = json_model.generate_content(prompt)
        cleaned_text = response.text.strip().strip("`").strip()
        if cleaned_text.startswith("json"):
            cleaned_text = cleaned_text[4:].strip()
        return json.loads(cleaned_text)
    except Exception as e:
        raise ValueError(f"Google AI analysis failed: {e}")


def start_chat_session(history):
    """Starts a chat session with the given history."""
    convo = chat_model.start_chat(history=history)
    return convo

def send_message_to_ai(convo, prompt):
    """Sends a new message to the ongoing conversation."""
    convo.send_message(prompt)
    return convo.last.text

# --- THE MISSING FUNCTION IS HERE ---
def download_file_content(file_url: str) -> bytes:
    """Downloads the raw content of a file from a URL."""
    with httpx.Client() as client:
        response = client.get(file_url)
        response.raise_for_status()
        return response.content

def extract_text_from_file(file_content: bytes, file_type: str) -> str:
    """
    Extracts text from file content.
    NOTE: This is a placeholder for now.
    """
    try:
        return file_content.decode('utf-8')
    except UnicodeDecodeError:
        return " [Content is binary and cannot be displayed as simple text] "

def chat_about_document(document_text: str, prompt: str) -> str:
    """
    Uses the AI to answer a question based on the provided document text.
    """
    full_prompt = f"""
    You are a helpful assistant. The user has provided you with the text from a document.
    Answer the user's question based ONLY on the information contained in the provided text.

    Here is the document text:
    ---
    {document_text}
    ---
    
    Here is the user's question:
    ---
    {prompt}
    ---
    """
    try:
        response = chat_model.generate_content(full_prompt)
        return response.text
    except Exception as e:
        raise ValueError(f"Google AI chat failed: {e}")