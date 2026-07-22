FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

RUN apt-get update && apt-get install -y \
    bash \
    curl \
    wget \
    git \
    jq \
    unzip \
    awscli \
    docker.io \
    procps \
    iproute2 \
    net-tools \
    iputils-ping \
    dnsutils \
    openssh-client \
    kubectl \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

RUN chmod +x scripts/*.sh
RUN chmod +x installer/*.sh

ENTRYPOINT ["bash","/app/scripts/cloudsec.sh"]