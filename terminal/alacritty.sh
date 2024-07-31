#!/bin/bash

# Alacritty - A fast, cross-platform, OpenGL terminal emulator
# https://github.com/alacritty/alacritty


if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Checking operating system..."

if grep -qi microsoft /proc/version; then
    log "Error: This script cannot be run on Windows Subsystem for Linux (WSL). Alacritty must be installed manually on Windows."
    exit 1
fi

log "Fetching package information for Alacritty..."
sudo apt-get update
if [[ $? -ne 0 ]]; then
    log "Error: Failed to update package information."
    exit 1
fi

log "Installing Alacritty..."
sudo apt-get install -y alacritty
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install Alacritty."
    exit 1
fi
log "Alacritty installed successfully."

log "Verifying Alacritty installation..."
alacritty --version
if [[ $? -ne 0 ]]; then
    log "Error: Alacritty installation verification failed."
    exit 1
fi
log "Alacritty installed and verified successfully."

log "Alacritty installation script completed."
