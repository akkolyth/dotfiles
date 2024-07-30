#!/bin/bash

# exa is a modern replacement for the venerable file-listing command-line program 
# https://github.com/ogham/exa


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

log "Installing exa..."
sudo apt-get install -y exa
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install exa."
    exit 1
fi
log "exa installed successfully."

log "Verifying exa installation..."
exa --version
if [[ $? -ne 0 ]]; then
    log "Error: exa installation verification failed."
    exit 1
fi
log "exa installed and verified successfully."