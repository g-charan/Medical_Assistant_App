# In AI/services/ai_services.py

import os
import google.generativeai as genai
from dotenv import load_dotenv

# Load the environment variables (like your API key)
load_dotenv()
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

# Set up the model configuration
generation_config = {
  "temperature": 0.9,
  "top_p": 1,
  "top_k": 1,
  "max_output_tokens": 2048,
}

# Initialize the Gemini Pro model
model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    generation_config=generation_config
)

def start_chat_session(history):
    """Starts a chat session with the given history."""
    # The 'history' parameter allows us to give the AI memory
    convo = model.start_chat(history=history)
    return convo

def send_message_to_ai(convo, prompt):
    """Sends a new message to the ongoing conversation."""
    convo.send_message(prompt)
    # We return only the text from the AI's last response
    return convo.last.text

def send_message_to_ai_stream(convo, prompt):
    """Sends a new message and yields the response chunks as they arrive."""
    # The stream=True parameter is the key to enabling streaming
    response_stream = convo.send_message(prompt, stream=True)
    for chunk in response_stream:
        # Yield each piece of text as it's generated
        yield chunk.text