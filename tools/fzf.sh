#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Fetching package information..."
sudo apt-get update
if [[ $? -ne 0 ]]; then
    log "Error: Failed to update package information."
    exit 1
fi

log "Installing fzf..."
sudo apt-get install -y fzf
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install fzf."
    exit 1
fi
log "fzf installed successfully."

log "Verifying fzf installation..."
fzf --version
if [[ $? -ne 0 ]]; then
    log "Error: fzf installation verification failed."
    exit 1
fi
log "fzf installed and verified successfully."

log "fzf installation script completed."
