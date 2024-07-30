#!/bin/bash

# Oh My Zsh is an open source, community-driven framework for managing your zsh configuration.
# https://github.com/ohmyzsh/ohmyzsh


if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Fetching package information for zsh..."
sudo apt-get update
if [[ $? -ne 0 ]]; then
    log "Error: Failed to update package information."
    exit 1
fi

log "Installing zsh..."
sudo apt-get install -y zsh
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install zsh."
    exit 1
fi
log "zsh installed successfully."

log "Verifying zsh installation..."
zsh --version
if [[ $? -ne 0 ]]; then
    log "Error: zsh installation verification failed."
    exit 1
fi
log "zsh installed and verified successfully."

log "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install Oh My Zsh."
    exit 1
fi
log "Oh My Zsh installed successfully."

log "zsh and Oh My Zsh installation script completed."