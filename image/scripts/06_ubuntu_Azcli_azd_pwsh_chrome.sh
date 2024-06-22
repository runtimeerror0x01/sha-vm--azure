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

log "Installing Azcli"
# Azure CLI and extensions installation
sudo curl -LsS https://aka.ms/InstallAzureCLIDeb | sudo bash 
# sudo curl -LsS https://aka.ms/InstallAzureCLIDeb | bash
az extension add --name managementpartner
log "Installed Azcli successfully"

log "Installing azd"
# azd installation
curl -fsSL https://aka.ms/install-azd.sh | sudo bash -s -- -a amd64
log "Installed azd successfully"

log "Installing Powershell"
response=$(curl -s -L -I -o /dev/null -w '%{url_effective}' https://github.com/PowerShell/PowerShell/releases/latest) \
    && PSLatestVersion=$(basename "$response" | tr -d 'v') \
    && sudo curl -Lo powershell.tar.gz "https://github.com/PowerShell/PowerShell/releases/download/v$PSLatestVersion/powershell-$PSLatestVersion-linux-x64.tar.gz" \
    && sudo mkdir -p /opt/microsoft/powershell/7 \
    && sudo tar zxf powershell.tar.gz -C /opt/microsoft/powershell/7 \
    && sudo chmod +x /opt/microsoft/powershell/7/pwsh \
    && sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh \
    && sudo rm -rf /powershell.tar.gz
log "Installed Powershell successfully"

log "Installing Powershell modules"
# Install PowerShell modules
sudo pwsh -c 'Install-Module -Name Az -Repository PSGallery -Scope AllUsers -Force' 
log "Installed Pwsh modules successfully"

# log "Installing Google Chrome"
# wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmour -o /usr/share/keyrings/chrome-keyring.gpg 
# sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list' 
# DEBIAN_FRONTEND=noninteractive sudo apt-get update 
# DEBIAN_FRONTEND=noninteractive sudo apt-get install -y google-chrome-stable

# # Download and install Chromedriver and headless-shell
# Versionlts=$(google-chrome --version | grep -oE '[0-9]+(\.[0-9]{1,4})+')
# chromedriver_url="https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$Versionlts"
# wget -O chromedriver_version.txt $chromedriver_url
# chromedriver_version=$(<chromedriver_version.txt)
# CHROME_DIR=/opt/google/chrome
# wget -q --continue -P $CHROME_DIR https://storage.googleapis.com/chrome-for-testing-public/$chromedriver_version/linux64/chromedriver-linux64.zip
# unzip $CHROME_DIR/chromedriver* -d $CHROME_DIR
# chmod +x $CHROME_DIR/chromedriver-linux64/chromedriver
# wget -q --continue -P $CHROME_DIR https://storage.googleapis.com/chrome-for-testing-public/$chromedriver_versio/linux64/chrome-headless-shell-linux64.zip
# unzip $CHROME_DIR/chrome-headless* -d $CHROME_DIR
# chmod +x $CHROME_DIR/chrome-headless-shell-linux64/chrome-headless-shell
# # export PATH="/opt/google/chrome-linux64:$PATH"
# # export PATH="/opt/google/chrome/chromedriver-linux64:$PATH"
# echo 'export PATH="/opt/google/chrome/chromedriver-linux64:$PATH"' | sudo tee -a /etc/profile.d/chromedriver.sh
# echo 'export PATH="/opt/google/chrome/chrome-headless-shell-linux64:$PATH"' | sudo tee -a /etc/profile.d/chromedriver.sh

# log "Installed Google Chrome Successfully"
