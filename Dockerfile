# MLflow for DigitalOcean App Platform - Matches Official Docker Setup
# Uses same base as official MLflow Docker image
FROM ghcr.io/mlflow/mlflow:v3.3.1

# Install additional dependencies needed for your setup (PostgreSQL + S3)
# This matches the official Docker setup command
RUN pip install --no-cache-dir psycopg2-binary boto3

# Verify installation
RUN python -c "import mlflow; print(f'✓ MLflow version: {mlflow.__version__}'); import mlflow.tracing; print('✓ Tracing support available')"

# Set environment variables for optimal MLflow operation
ENV MLFLOW_ENABLE_TRACING=true
ENV MLFLOW_ENABLE_RICH_LOGGING=false
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Expose port (DigitalOcean will handle port mapping)
EXPOSE 5000

# No CMD - DigitalOcean will specify the run command