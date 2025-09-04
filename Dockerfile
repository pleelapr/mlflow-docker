# MLflow 3.3.2 with Full GenAI Tracing Support
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /mlflow

# Install MLflow 3.3.2 with ALL extras and GenAI support
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    "mlflow[extras]==3.3.2" \
    psycopg2-binary \
    boto3 \
    gunicorn \
    "langchain>=0.1.0,<0.4.0" \
    "langchain-openai>=0.1.0" \
    "langchain-community>=0.0.20" \
    "langgraph>=0.0.30" \
    "openai>=1.0.0" \
    "anthropic>=0.20.0" \
    "llamaindex>=0.10.0" \
    "dspy-ai>=2.4.0" \
    "autogen-agentchat>=0.2.0" \
    && pip cache purge

# Verify MLflow version and GenAI support
RUN python -c "import mlflow; print(f'MLflow version: {mlflow.__version__}'); import mlflow.tracing; import mlflow.langchain; print('✓ GenAI tracing support available')"

# Set environment variables for tracing
ENV MLFLOW_ENABLE_TRACING=true
ENV MLFLOW_ENABLE_RICH_LOGGING=false
ENV PYTHONUNBUFFERED=1

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Expose port
EXPOSE 5000

# Default command (can be overridden)
CMD ["mlflow", "server", "--host", "0.0.0.0", "--port", "5000"]