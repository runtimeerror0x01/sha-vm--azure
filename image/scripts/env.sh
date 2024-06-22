#!/bin/bash
logfile=/var/log/provisioner.log
## Function to echo action with time stamp
log() {
    echo "$(date +'%X %x') $1" | sudo tee -a $logfile
}
# Set environment variables
export AZP_URL="$(AZP_URL)"
export AZP_TOKEN="$(AZP_TOKEN)"
export AZP_POOL="$(AZP_POOL)"
export AZP_AGENT_NAME="$(AZP_AGENT_NAME)"
export TARGETARCH="$(TARGETARCH)"
# export VMUSER="$(VMUSER)"

          #### Allow users to SSH ####
# sudo sed -i '/^AllowUsers / s/$/ '"$VMUSER"'/' /etc/ssh/sshd_config
# sudo systemctl reload sshd

echo "Creating /etc/profile.d/azp_env.sh to set environment variables globally..."
log "Creating /etc/profile.d/azp_env.sh to set environment variables globally..."

sudo tee /etc/profile.d/azp_env.sh > /dev/null <<EOL
#!/bin/bash

export AZP_URL="$AZP_URL"
export AZP_TOKEN="$AZP_TOKEN"
export AZP_POOL="$AZP_POOL"
export AZP_AGENT_NAME="$AZP_AGENT_NAME"
export TARGETARCH="$TARGETARCH"
EOL

# Make the script executable
sudo chmod +x /etc/profile.d/azp_env.sh

# Apply the changes to the current session
source /etc/profile.d/azp_env.sh
cat /etc/profile.d/azp_env.sh
# Confirm that the variables are available in the current session
echo "Environment variables have been set."





