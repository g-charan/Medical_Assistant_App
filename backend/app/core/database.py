from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# --- IMPORTANT ---
# Replace the placeholder URL below with your actual PostgreSQL connection string.
# Format: "postgresql://<user>:<password>@<host>:<port>/<database_name>"
SQLALCHEMY_DATABASE_URL ="postgresql://postgres.vqizlywojeyrqafztcst:Jalapeno3-Thirty5-Rumble1-Makeover2-Opal5@aws-0-ap-south-1.pooler.supabase.com:5432/postgres"

engine = create_engine(SQLALCHEMY_DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()