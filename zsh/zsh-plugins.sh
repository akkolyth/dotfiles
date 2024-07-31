#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

log "Cloning zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
if [[ $? -ne 0 ]]; then
    log "Error: Failed to clone zsh-autosuggestions."
    exit 1
fi
log "zsh-autosuggestions cloned successfully."

log "Cloning zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
if [[ $? -ne 0 ]]; then
    log "Error: Failed to clone zsh-syntax-highlighting."
    exit 1
fi
log "zsh-syntax-highlighting cloned successfully."

log "Cloning you-should-use..."
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$ZSH_CUSTOM/plugins/you-should-use"
if [[ $? -ne 0 ]]; then
    log "Error: Failed to clone you-should-use."
    exit 1
fi
log "you-should-use cloned successfully."

log "zsh plugins installation completed successfully."
