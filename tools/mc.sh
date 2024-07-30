#!/bin/bash

# GNU Midnight Commander is a visual file manager
# https://midnight-commander.org/

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Adding universe repository..."
sudo add-apt-repository -y universe
if [[ $? -ne 0 ]]; then
    log "Error: Failed to add universe repository."
    exit 1
fi
log "Universe repository added successfully."

log "Fetching package information..."
sudo apt-get update
if [[ $? -ne 0 ]]; then
    log "Error: Failed to update package information."
    exit 1
fi

log "Installing mc (Midnight Commander)..."
sudo apt-get install -y mc
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install mc."
    exit 1
fi
log "mc installed successfully."

log "Installing Dracula theme for mc..."
mkdir -p ~/dracula-theme && cd ~/dracula-theme

if [[ -d "midnight-commander" ]]; then
    log "Dracula theme directory already exists. Pulling latest changes..."
    cd midnight-commander
    git pull origin main
else
    git clone https://github.com/dracula/midnight-commander.git
    if [[ $? -ne 0 ]]; then
        log "Error: Failed to clone Dracula theme repository."
        exit 1
    fi
fi

mkdir -p ~/.local/share/mc/skins && cd ~/.local/share/mc/skins

ln -sf ~/dracula-theme/midnight-commander/skins/dracula.ini
ln -sf ~/dracula-theme/midnight-commander/skins/dracula256.ini

if [[ $? -ne 0 ]]; then
    log "Error: Failed to create symlinks for Dracula theme."
    exit 1
fi
log "Dracula theme installed and configured successfully."

log "All tasks completed successfully."
