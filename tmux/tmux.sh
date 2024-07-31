#!/bin/bash

# tmux is a terminal multiplexer: it enables a number of terminals to be created, accessed, and controlled from a single screen.
# https://github.com/tmux/tmux


if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Fetching package information for tmux..."
sudo apt-get update
if [[ $? -ne 0 ]]; then
    log "Error: Failed to update package information."
    exit 1
fi

log "Installing tmux..."
sudo apt-get install -y tmux
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install tmux."
    exit 1
fi
log "tmux installed successfully."

log "Verifying tmux installation..."
tmux -V
if [[ $? -ne 0 ]]; then
    log "Error: tmux installation verification failed."
    exit 1
fi
log "tmux installed and verified successfully."

log "tmux installation script completed."