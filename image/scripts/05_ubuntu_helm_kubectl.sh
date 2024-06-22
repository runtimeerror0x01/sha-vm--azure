#!/bin/bash
## Provisioner log file
logfile=/var/log/provisioner.log
## Function to echo action with time stamp
log() {
    echo "$(date +'%X %x') $1" | sudo tee -a $logfile
}

log "Updating Operating System"
DEBIAN_FRONTEND=noninteractive sudo apt-get update
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y

sleep 5

log "Installing Helm"
# Helm installation
# # wget https://baltocdn.com/helm/signing.asc || handle_error "Failed to download signing key"
# # sudo apt-key add signing.asc || handle_error "Failed to add signing key"
# sudo wget -q https://baltocdn.com/helm/signing.asc -O /etc/apt/trusted.gpg.d/helm.gpg 
# # echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# echo "deb [signed-by=/etc/apt/trusted.gpg.d/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

curl -fsSL https://baltocdn.com/helm/signing.asc | sudo gpg --dearmor -o /usr/share/keyrings/helm.gpg
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list


DEBIAN_FRONTEND=noninteractive sudo apt-get update
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y helm 
export HELM_HOME=/helm 
log "Installed Helm Successfully"

# Download Helm signing key

# Add Helm repository
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list



echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' | sudo tee -a /root/.bashrc

log "Installing Kubectl"
# Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" 
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl 
log "Installed Kubectl Successfully"

echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' | sudo tee -a /root/.bashrc
