#!/bin/bash
## Provisioner log file
logfile=/var/log/provisioner.log
## Function to echo action with time stamp
log() {
    echo "$(date +'%X %x') $1" | sudo tee -a $logfile
}

log "Starting provisioning process"

DEBIAN_FRONTEND=noninteractive sudo apt-get update 
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y
sleep 5

log "Installing Node.js & Yarn"
# Node.js and Yarn installation
DEBIAN_FRONTEND=noninteractive sudo apt remove -y libnode-dev
DEBIAN_FRONTEND=noninteractive sudo apt remove -y libnode72:amd64
DEBIAN_FRONTEND=noninteractive sudo apt-get update
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y -f nodejs 

sudo npm install -g yarn 
log "Installed Node.js & Yarn Successfully."

echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' | sudo tee -a /root/.bashrc

log "Installing Maven"
# Maven and Gradle installation
sudo apt-mark hold default-jdk
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y maven
log "Installed maven Successfully."

echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' | sudo tee -a /root/.bashrc

log "Setting up environment variables for Gradle"
USER_HOME_DIR="/root"
GRADLE_VERSION=8.6
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
PATH="${PATH}:/usr/local/gradle/bin"
MAVEN_HOME=/usr/share/maven
MAVEN_CONFIG="$USER_HOME_DIR/.m2"
export JAVA_HOME PATH MAVEN_HOME MAVEN_CONFIG

# log "Installing Gradle"
# wget -q https://services.gradle.org/distributions/gradle-$GRADLE_VERSION.zip || handle_error "Failed to download Gradle"
# sudo unzip -q gradle-$GRADLE_VERSION.zip -d /usr/local || handle_error "Failed to unzip Gradle"
# sudo rm gradle-$GRADLE_VERSION.zip || handle_error "Failed to remove Gradle zip file"
# sudo ln -sfn /usr/local/gradle-$GRADLE_VERSION /usr/local/gradle || handle_error "Failed to create symbolic link for Gradle"
# log "Gradle installed successfully"

# echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' | sudo tee -a /root/.bashrc

#   check gradle wget