#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
    echo "Run as root"
    exit 1
fi

ZSH_DIR=${ZSH:-$HOME/.oh-my-zsh}
ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH_DIR/custom}

echo "Updating packages..."
apt-get update -y

echo "Installing Zsh, curl, and git..."
apt-get install -y zsh curl git

zsh --version

if [[ -d "$ZSH_DIR" ]]; then
    echo "Removing existing Oh My Zsh at $ZSH_DIR..."
    rm -rf "$ZSH_DIR"
fi

echo "Installing Oh My Zsh..."
export RUNZSH="no"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$ZSH_CUSTOM/plugins/you-should-use"

echo "Done."
