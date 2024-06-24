#!/bin/bash

# Provisioner log file
logfile=/var/log/provisioner.log

# Function to echo action with timestamp
log() {
    echo "$(date +'%X %x') $1" | sudo tee -a $logfile
}

# Ensure the system has the required repositories and update the package lists
log "Updating repository information and configuring repositories"

# Adding universe and multiverse repositories for additional packages
sudo add-apt-repository universe -y >> $logfile 2>&1
sudo add-apt-repository multiverse -y >> $logfile 2>&1

# Updating repository information after adding repositories
sudo apt update -y >> $logfile 2>&1

log "Updating Operating System"
DEBIAN_FRONTEND=noninteractive sudo apt upgrade -y >> $logfile 2>&1

log "Installing basic packages for smooth system functioning"
DEBIAN_FRONTEND=noninteractive sudo apt install -y bash-completion \
        build-essential \
        git \
        apt-transport-https \
        ca-certificates \
        apt-utils \
        iputils-ping \
        curl \
        file \
        gnupg \
        gnupg-agent \
        locales \
        sudo \
        time \
        unzip \
        wget \
        zip \
        jq \
        netcat \
        software-properties-common \
        python3 \
        python3-pip \
        dnsutils \
        openssl \
        net-tools \
        lld \
        libcurl4 \
        libxss1 \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libatspi2.0-0 \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        libgbm1 \
        libxkbcommon0 \
        libpango-1.0-0 \
        libcairo2 \
        libc6 \
        libgcc-s1 \
        libgssapi-krb5-2 \
        libicu70 \
        liblttng-ust1 \
        libssl3 \
        libstdc++6 \
        libunwind8 \
        zlib1g \
        npm \
        dotnet-sdk-8.0 \
        default-jdk >> $logfile 2>&1

log "Provisioning completed successfully"
