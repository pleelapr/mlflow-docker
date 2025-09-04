FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir \
    mlflow[auth] \
    psycopg2-binary \
    boto3 \
    gunicorn \
    scikit-learn \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    requests \
    pyarrow

# Create non-root user for security
RUN useradd -m -u 1000 mlflow && \
    chown -R mlflow:mlflow /app

USER mlflow

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Default command (will be overridden by run command)
CMD ["mlflow", "server", "--host", "0.0.0.0", "--port", "5000"]