#!/bin/bash

# Logging function
log() {
    echo "$1"
}

log "Starting installation of ChromeDriver and Chrome headless shell"

# Define URLs for downloading ChromeDriver and headless shell for linux64
CHROMEDRIVER_URL="https://storage.googleapis.com/chrome-for-testing-public/125.0.6422.60/linux64/chromedriver-linux64.zip"
HEADLESS_SHELL_URL="https://storage.googleapis.com/chrome-for-testing-public/125.0.6422.60/linux64/chrome-headless-shell-linux64.zip"

# Define temporary download directory
TEMP_DIR="/tmp/chrome_install"
CHROMEDRIVER_ZIP="$TEMP_DIR/chromedriver-linux64.zip"
HEADLESS_SHELL_ZIP="$TEMP_DIR/chrome-headless-shell-linux64.zip"

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Download ChromeDriver
log "Downloading ChromeDriver from $CHROMEDRIVER_URL"
wget -q -O "$CHROMEDRIVER_ZIP" "$CHROMEDRIVER_URL"
if [ $? -ne 0 ]; then
    log "Failed to download ChromeDriver"
    exit 1
fi

# Download Chrome headless shell
log "Downloading Chrome headless shell from $HEADLESS_SHELL_URL"
wget -q -O "$HEADLESS_SHELL_ZIP" "$HEADLESS_SHELL_URL"
if [ $? -ne 0 ]; then
    log "Failed to download Chrome headless shell"
    exit 1
fi

# Extract ChromeDriver
log "Extracting ChromeDriver"
unzip -q "$CHROMEDRIVER_ZIP" -d "$TEMP_DIR"
if [ $? -ne 0 ]; then
    log "Failed to extract ChromeDriver"
    exit 1
fi

# Extract Chrome headless shell
log "Extracting Chrome headless shell"
unzip -q "$HEADLESS_SHELL_ZIP" -d "$TEMP_DIR"
if [ $? -ne 0 ]; then
    log "Failed to extract Chrome headless shell"
    exit 1
fi

# Move ChromeDriver to /usr/local/bin
log "Installing ChromeDriver"
sudo mv "$TEMP_DIR/chromedriver-linux64/chromedriver" /usr/local/bin/chromedriver
sudo chmod +x /usr/local/bin/chromedriver

# Move Chrome headless shell to /usr/local/bin
log "Installing Chrome headless shell"
sudo mv "$TEMP_DIR/chrome-headless-shell-linux64/chrome-headless-shell" /usr/local/bin/chrome-headless-shell
sudo chmod +x /usr/local/bin/chrome-headless-shell

# Clean up temporary directory
log "Cleaning up"
rm -rf "$TEMP_DIR"

log "Installation completed successfully"
