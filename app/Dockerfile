# Use minimal, secure base image , no need to install python via apt 
# Use exact tag instead of latest, for re-produceable builds
FROM python:3.11-slim

# Set environment variables to optimize some sizing and logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user
RUN useradd -m appuser

# Copy application code
COPY . .

# Change ownership
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose non-privileged port
EXPOSE 8000

# Run with production server 
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
