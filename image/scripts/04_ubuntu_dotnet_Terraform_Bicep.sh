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

# log "Installing .NET"
# # # .NET installation
# wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh || handle_error "Failed to download .net"
# sudo sh dotnet-install.sh --version latest || handle_error "Failed to install .net"
# export DOTNET_ROOT=$HOME/.dotnet
# export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
# # Set the DOTNET_ROOT and PATH variables
# echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
# echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' >> ~/.bashrc
# log "Installed .NET Successfully"

log "Installing Terraform" #check
# Terraform installation
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
log "Updating Operating System"
DEBIAN_FRONTEND=noninteractive sudo apt-get update
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y terraform 
log "Installed Terraform Successfully"

echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' | sudo tee -a /root/.bashrc

log "Installing Bicep"
# Bicep installation
curl -Lo bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64 
chmod a+x ./bicep
DEBIAN_FRONTEND=noninteractive sudo mv ./bicep /usr/local/bin/bicep
log "Installed Bicep successfully"

echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' | sudo tee -a /root/.bashrc


