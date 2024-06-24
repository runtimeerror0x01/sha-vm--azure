#!/bin/bash

## Provisioner log file
logfile=/var/log/validation.log

## Function to echo action with time stamp
log() {
    echo "$(date +'%X %x') $1" | sudo tee -a $logfile
}
check_package() {
    local package="$1"

    # Capture dpkg -l output and process it
    local dpkg_output
    dpkg_output="$(dpkg -l)"
    echo "DPKG Output:"
    echo "$dpkg_output"  # Debug: Display dpkg -l output

    # Process each line to check if package is installed
    if echo "$dpkg_output" | grep -q "^ii[[:space:]]*$package[[:space:]]"; then
        log "Package $package is installed."
    else
        log "Package $package is NOT installed."
    fi
}
# log "Checking installed packages"
# check_package() {
#     if dpkg -l | grep -q "^ii  $1 "; then
#         log "Package $1 is installed."
#     else
#         log "Package $1 is NOT installed."
#     fi
# }

packages=(
    "bash-completion"
    "build-essential"
    "git"
    "apt-transport-https"
    "ca-certificates"
    "apt-utils"
    "iputils-ping"
    "curl"
    "file"
    "gnupg"
    "gnupg-agent"
    "locales"
    "sudo"
    "time"
    "unzip"
    "wget"
    "zip"
    "jq"
    "netcat"
    "software-properties-common"
    "python3"
    "python3-pip"
    "dnsutils"
    "openssl"
    "net-tools"
    "lld"
    "libcurl4"
    "libxss1"
    "libnss3"
    "libatk1.0-0"
    "libatk-bridge2.0-0"
    "libatspi2.0-0"
    "libxcomposite1"
    "libxdamage1"
    "libxrandr2"
    "libgbm1"
    "libxkbcommon0"
    "libpango-1.0-0"
    "libcairo2"
    "libc6"
    "libgcc-s1"
    "libgssapi-krb5-2"
    "libicu70"
    "liblttng-ust1"
    "libssl3"
    "libstdc++6"
    "libunwind8"
    "zlib1g"
    "npm"
    "dotnet-sdk-8.0"
    "default-jdk"
)

for package in "${packages[@]}"; do
    check_package "$package"
done

log "Provisioning completed successfully"
