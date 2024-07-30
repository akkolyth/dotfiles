#!/bin/bash

# A cat(1) clone with syntax highlighting and Git integration.
# https://github.com/sharkdp/bat

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

log "Installing bat..."
sudo apt-get install -y bat
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install bat."
    exit 1
fi
log "bat installed successfully."


log "Creating local bin directory and setting up symlink..."
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
if [[ $? -ne 0 ]]; then
    log "Error: Failed to create symlink."
    exit 1
fi
log "Symlink created successfully."

log "Verifying bat installation..."
batcat --version
if [[ $? -ne 0 ]]; then
    log "Error: bat installation verification failed."
    exit 1
fi
log "bat installed and verified successfully."

log "bat installation script completed."
