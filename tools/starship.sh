#!/bin/bash

# The minimal, blazing-fast, and infinitely customizable prompt for any shell!
# https://starship.rs/

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Fetching package information for starship..."
sudo apt-get update
if [[ $? -ne 0 ]]; then
    log "Error: Failed to update package information."
    exit 1
fi

log "Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install Starship prompt."
    exit 1
fi
log "Starship prompt installed successfully."

log "Starship prompt installation script completed."
