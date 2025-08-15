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
    """
    Analyze OCR text from medicine packaging and return consistent JSON structure.
    """
    prompt = f"""
    Analyze the following text from a medicine package and respond in JSON format.
    IMPORTANT: 
    1. Provide all text responses in English language only.
    2. Use EXACTLY this JSON structure (do not change field names):
    {{
        "analysis": {{
            "product_name": "name of the medicine product",
            "interpretation": "detailed description of what this medicine is used for and any important information"
        }}
    }}

    Text to analyze:
    ---
    {text}
    ---
    
    Respond with ONLY the JSON, no other text or formatting.
    """
    
    messages = [
        {"role": "system", "content": "You are a helpful assistant that responds in JSON format only. Always use the exact field names requested."},
        {"role": "user", "content": prompt}
    ]
    
    try:
        response = make_chat_completion_request(MODEL, messages, temperature=0.1)  # Lower temperature for consistency
        raw_text = response.choices[0].message.content
        
        # Clean up the response
        cleaned_text = raw_text.strip()
        if cleaned_text.startswith("```json"):
            cleaned_text = cleaned_text[7:]
        if cleaned_text.endswith("```"):
            cleaned_text = cleaned_text[:-3]
        cleaned_text = cleaned_text.strip()
        
        # Parse JSON
        result = json.loads(cleaned_text)
        
        # Validate structure and fix if needed
        if "analysis" not in result:
            # If structure is wrong, try to fix it
            if "product_name" in result and "interpretation" in result:
                result = {"analysis": result}
            else:
                raise ValueError("Invalid response structure from AI")
        
        # Ensure required fields exist
        analysis = result["analysis"]
        if "product_name" not in analysis:
            analysis["product_name"] = "Unknown Medicine"
        if "interpretation" not in analysis:
            analysis["interpretation"] = "No description available"
            
        return result
        
    except APIConnectionError as e:
        raise ValueError(f"Connection to AI service failed after multiple retries: {e}")
    except (json.JSONDecodeError, KeyError, ValueError) as e:
        print(f"AI returned invalid JSON: {raw_text}")
        # Return a fallback structure
        return {
            "analysis": {
                "product_name": "Unknown Medicine", 
                "interpretation": f"Could not analyze the provided text. Raw response: {str(e)[:100]}..."
            }
        }

# --- Existing Chat Functions ---
def start_chat_session(history):
    return history

# from googletrans import Translator, LANGUAGES

# # ... (keep all your other existing functions like analyze_ocr_text, send_message_to_ai, etc.)

# def translate_to_english(text: str) -> str:
#     """
#     Detects the language of the text and translates it to English if it's not already English.
#     Returns the original text if translation fails or if it's already English.
#     """
#     # Avoid errors with empty or whitespace-only strings
#     if not text or not text.strip():
#         return text

#     try:
#         translator = Translator()
#         # Detect the language of the source text
#         detected_lang = translator.detect(text).lang

#         # Check if the detected language is supported and is not English ('en')
#         if detected_lang in LANGUAGES and detected_lang != 'en':
#             print(f"Detected language: {LANGUAGES.get(detected_lang, 'Unknown')}. Translating to English.")
#             # Translate the text from the detected language to English
#             translated_text = translator.translate(text, dest='en').text
#             return translated_text
#         else:
#             # If it's already English or detection is uncertain, return the original text
#             return text
#     except Exception as e:
#         print(f"An error occurred during translation: {e}")
#         # Fallback to returning the original text in case of any API errors
#         return text

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