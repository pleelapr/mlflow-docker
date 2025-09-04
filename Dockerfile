FROM ghcr.io/mlflow/mlflow:latest
RUN pip install psycopg2-binary boto3
ENV MLFLOW_ENABLE_TRACING=true