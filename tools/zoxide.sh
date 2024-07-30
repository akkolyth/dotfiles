#!/bin/bash

# zoxide is a smarter cd command, inspired by z and autojump.
# https://github.com/ajeetdsouza/zoxide


if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Verifying zsh installation..."
if ! command -v zsh &> /dev/null; then
    log "Error: zsh is not installed. Please install zsh before running this script."
    exit 1
fi
log "zsh is already installed."

log "Installing Zoxide..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install Zoxide."
    exit 1
fi
log "Zoxide installed successfully."

log "Zoxide installation script completed."
