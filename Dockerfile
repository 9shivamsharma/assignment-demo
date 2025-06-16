# Use official Python image as base (slim variant is smaller and more secure)
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy project files
COPY . .

# Create non-root user for security
RUN useradd -m appuser
USER appuser

# Expose the port
EXPOSE 8000

# Start the app with Gunicorn
CMD ["gunicorn", "app.main:app", "-b", "0.0.0.0:8000", "--workers=4", "--threads=2", "--timeout=120"]
