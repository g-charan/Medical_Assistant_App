import os
import json
import httpx  # Add this import for downloading files
from openai import OpenAI, APIConnectionError
from dotenv import load_dotenv
from tenacity import retry, stop_after_attempt, wait_exponential

load_dotenv()

# Initialize the OpenAI client, pointing to OpenRouter's API
client = OpenAI(
    api_key=os.getenv("OPENROUTER_API_KEY"),
    base_url="https://openrouter.ai/api/v1"
)
MODEL = "deepseek/deepseek-chat"

# --- Existing Chat Completion Request Function ---
@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=4, max=10),
    retry=lambda e: isinstance(e, APIConnectionError)
)
def make_chat_completion_request(model, messages, temperature=1.0):
    """A robust wrapper for making the API call that includes retries."""
    print("Attempting to call AI API...")
    return client.chat.completions.create(
        model=model,
        messages=messages,
        temperature=temperature
    )

# --- Existing OCR Analysis Function ---
def analyze_ocr_text(text: str) -> dict:
    # ... (code for this function remains the same)
    prompt = f"""
    Analyze the following text from a medicine package...
    Text to analyze:
    ---
    {text}
    ---
    """
    messages = [{"role": "system", "content": "You are a helpful assistant that responds in JSON."}, {"role": "user", "content": prompt}]
    try:
        response = make_chat_completion_request(MODEL, messages, temperature=0.2)
        raw_text = response.choices[0].message.content
        cleaned_text = raw_text.strip().strip("`").strip()
        if cleaned_text.startswith("json"):
            cleaned_text = cleaned_text[4:].strip()
        return json.loads(cleaned_text)
    except APIConnectionError as e:
        raise ValueError(f"Connection to AI service failed after multiple retries: {e}")
    except (json.JSONDecodeError, IndexError):
        raise ValueError(f"AI returned a non-JSON or empty response.")

# --- Existing Chat Functions ---
def start_chat_session(history):
    return history

def send_message_to_ai(convo, prompt):
    # ... (code for this function remains the same)
    convo.append({"role": "user", "content": prompt})
    try:
        response = make_chat_completion_request(MODEL, convo)
        ai_response_text = response.choices[0].message.content
        convo.append({"role": "assistant", "content": ai_response_text})
        return ai_response_text
    except APIConnectionError as e:
        raise ValueError(f"Connection to AI service failed after multiple retries: {e}")

# --- NEW FILE PROCESSING FUNCTIONS ---

def download_file_content(file_url: str) -> bytes:
    """Downloads the raw content of a file from a URL."""
    with httpx.Client() as client:
        response = client.get(file_url)
        response.raise_for_status()  # Raise an exception for bad status codes
        return response.content

def extract_text_from_file(file_content: bytes, file_type: str) -> str:
    """
    Extracts text from file content.
    NOTE: This is a placeholder. Real implementation would require libraries
    like PyPDF2 for PDFs or an OCR library for images.
    """
    print(f"Attempting to extract text from a file of type: {file_type}")
    # For now, we'll simulate text extraction by decoding the bytes.
    # This will work for simple text files but not for complex PDFs or images.
    try:
        # A simple placeholder for text extraction
        return file_content.decode('utf-8')
    except UnicodeDecodeError:
        return " [Content is binary and cannot be displayed as simple text] "

def chat_about_document(document_text: str, prompt: str) -> str:
    """
    Uses the AI to answer a question based on the provided document text.
    """
    system_prompt = "You are a helpful assistant. The user has provided you with the text from a document. Answer the user's question based ONLY on the information contained in the provided text."
    
    full_prompt = f"""
    Here is the document text:
    ---
    {document_text}
    ---
    
    Here is the user's question:
    ---
    {prompt}
    ---
    
    Please answer the question based only on the document text.
    """
    
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": full_prompt}
    ]
    
    try:
        response = make_chat_completion_request(MODEL, messages)
        return response.choices[0].message.content
    except APIConnectionError as e:
        raise ValueError(f"Connection to AI service failed after multiple retries: {e}")