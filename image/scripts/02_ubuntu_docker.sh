#!/bin/bash
## Provisioner log file
logfile=/var/log/provisioner.log
VMUSER="$(VMUSER)"
## Function to echo action with time stamp
log() {
    echo "$(date +'%X %x') $1" | sudo tee -a $logfile
}

DEBIAN_FRONTEND=noninteractive sudo apt-get update 
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y
sleep 5
## Function to install fail2ban (Resolves docker installation error)
install_fail2ban() {
    log "Installing fail2ban"
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -y -qq fail2ban
}
## Function to enable and configure fail2ban
enable_fail2ban() {
    log "Enabling fail2ban"
    sudo systemctl enable fail2ban.service 
    
    log "Configuring fail2ban"
    echo "[sshd]
enabled = true
filter = sshd
bantime = 30m
findtime = 30m
maxretry = 5
" | sudo tee /etc/fail2ban/jail.local 
    
    log "Restarting fail2ban"
    sudo systemctl restart fail2ban.service 
}
sleep 5
log "Installing Docker"
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh 

log "Enable Docker"
sudo systemctl enable docker.service 

log "System hardening"
echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' | sudo tee -a /root/.bashrc
echo "
########################################################################
# Authorized access only!
# If you are not authorized to access or use this system, disconnect now!
########################################################################
"| sudo tee /etc/mybanner

log "Hardening System"
sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config_org
echo "AuthorizedKeysFile .ssh/authorized_keys
Protocol 2
Banner /etc/mybanner
PermitRootLogin no
PasswordAuthentication yes
PermitEmptyPasswords no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
AllowUsers $VMUSER
X11Forwarding no
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
" | sudo tee /etc/ssh/sshd_config
sudo systemctl reload sshd.service

log "Enable firewall & allow SSH, HTTP, HTTPS services"
echo "y" | sudo ufw enable 
sudo ufw allow 22 
sudo ufw allow out 80 
sudo ufw allow out 443 

log "Docker Installation completed successfully"

log "Installing Ansible"

UBUNTU_CODENAME=jammy
wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y -qq ansible

log "Ansible installed successfully"
