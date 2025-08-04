# In app/core/database.py

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()

# Get the database URL from your .env file
SQLALCHEMY_DATABASE_URL = os.getenv("DATABASE_URL")

# We are adding pool configuration to the create_engine call
engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    pool_size=5,          # Limit the number of connections in the pool
    max_overflow=2,       # Allow 2 extra connections in case of a spike
    pool_recycle=300,     # Recycle connections every 300 seconds (5 minutes)
    pool_pre_ping=True    # Check if a connection is alive before using it
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()