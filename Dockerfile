# MLflow 3.3.2 for DigitalOcean App Platform
# Optimized for DO builds with custom run commands
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /mlflow

# Install MLflow 3.3.2 with full GenAI and UI support
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    "mlflow[extras]==3.3.2" \
    psycopg2-binary \
    boto3 \
    gunicorn \
    "langchain>=0.1.0,<0.4.0" \
    "langchain-openai>=0.1.0" \
    "langchain-community>=0.0.20" \
    "openai>=1.0.0" \
    && pip cache purge

# Verify MLflow installation and GenAI support
RUN python -c "import mlflow; print(f'✓ MLflow version: {mlflow.__version__}'); import mlflow.tracing; import mlflow.langchain; import mlflow.openai; print('✓ GenAI tracing support available')"

# Set environment variables for optimal MLflow operation
ENV MLFLOW_ENABLE_TRACING=true
ENV MLFLOW_ENABLE_RICH_LOGGING=false
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Expose port (DigitalOcean will handle port mapping)
EXPOSE 5000

# No CMD - DigitalOcean will specify the run command