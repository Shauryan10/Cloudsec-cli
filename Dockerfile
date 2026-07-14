FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Install required packages
RUN apt-get update && \
    apt-get install -y \
        bash \
        curl \
        wget \
        jq \
        unzip \
        zip \
        procps \
        net-tools \
        iproute2 \
        iputils-ping \
        dnsutils \
        openssh-client \
        ufw \
        sudo \
        ca-certificates \
        python3 \
        python3-pip && \
    rm -rf /var/lib/apt/lists/*

# AWS CLI
RUN pip3 install --break-system-packages awscli

# Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io && \
    rm -rf /var/lib/apt/lists/*

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
 && install -m 0755 kubectl /usr/local/bin/kubectl \
 && rm kubectl

# Copy project
COPY . /app

# Make scripts executable
RUN chmod +x bin/cloudsec && \
    chmod +x scripts/*.sh

# Reports directory
RUN mkdir -p reports history logs

ENTRYPOINT ["bash","./bin/cloudsec"]