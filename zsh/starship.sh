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
apt-get update -y
if [[ $? -ne 0 ]]; then
    log "Error: Failed to update package information."
    exit 1
fi

log "Downloading the Starship installation script..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

if [[ $? -ne 0 ]]; then
    log "Error: Failed to download the Starship installation script."
    exit 1
fi

log "Starship prompt installed successfully."
