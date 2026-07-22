FROM python:3.12-slim

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Install Linux utilities required by CloudSec
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    wget \
    jq \
    procps \
    iproute2 \
    net-tools \
    iputils-ping \
    docker.io \
    ca-certificates \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir \
    boto3 \
    awscli \
    jinja2

# Copy complete project
COPY . .

# Make every shell script executable
RUN chmod +x scripts/cloudsec.sh && \
    find scripts -name "*.sh" -exec chmod +x {} \;

# Create reports directory
RUN mkdir -p reports

# Default AWS region
ENV AWS_DEFAULT_REGION=ap-south-1

# Entry point
ENTRYPOINT ["./scripts/cloudsec.sh"]