#!/bin/bash
## Provisioner log file
logfile=/var/log/provisioner.log
sudo touch $logfile
sudo chown $(whoami):$(whoami) $logfile
## Function to echo action with time stamp
log() {
    echo "$(date +'%X %x') $1" | sudo tee -a $logfile
}

sudo add-apt-repository universe -y >> $logfile 2>&1
sudo add-apt-repository multiverse -y >> $logfile 2>&1

log "Updating Operating System"
DEBIAN_FRONTEND=noninteractive sudo apt-get update
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y

log "Installing basic packages for smooth system functioning"
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y bash-completion >> $logfile 2>&1
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
        build-essential \
        git \
        apt-transport-https \
        ca-certificates \
        apt-utils \
        iputils-ping \
        curl \
        file \
        git \
        gnupg \
        gnupg-agent \
        locales \
        sudo \
        time >> $logfile 2>&1
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
        unzip \
        wget \
        zip \
        jq \
        netcat \
        software-properties-common \
        build-essential >> $logfile 2>&1
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
        python3 \
        python3-pip \
        dnsutils \
        openssl \
        net-tools >> $logfile 2>&1
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
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
        zlib1g >> $logfile 2>&1
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
        npm \
        dotnet-sdk-8.0 \
        default-jdk >> $logfile 2>&1     

    log "Provisioning completed successfully"

