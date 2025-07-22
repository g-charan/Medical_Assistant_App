# In get_token.py
import os
from supabase import create_client, Client

# --- FILL IN THESE FOUR VALUES ---
SUPABASE_URL = "https://vqizlywojeyrqafztcst.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxaXpseXdvamV5cnFhZnp0Y3N0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxOTgwMTksImV4cCI6MjA2ODc3NDAxOX0.AViEF_5qVqC5jB824_tX4FGyweDuLYljhgam93TXuwM"
TEST_USER_EMAIL = "test@example.com"
TEST_USER_PASSWORD = "password"
# ------------------------------------

try:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

    # Sign in as the test user
    response = supabase.auth.sign_in_with_password({
        "email": TEST_USER_EMAIL,
        "password": TEST_USER_PASSWORD
    })

    # Get the JWT (access token) from the session
    jwt_token = response.session.access_token

    print("\n--- COPY YOUR TOKEN BELOW ---\n")
    print(jwt_token)
    print("\n---------------------------\n")

except Exception as e:
    print(f"An error occurred: {e}")