#!/bin/bash

set -e

require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
    fi
}

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

verify_binary() {
    command -v "$1" >/dev/null && "$1" --version || {
        log "Error: $1 installation verification failed."
        exit 1
    }
}

require_root
log "Installing LazyDocker..."
VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep -Po '"tag_name": "v\K[0-9.]+' )
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${VERSION}_Linux_x86_64.tar.gz"
mkdir -p lazydocker-temp
tar -xzf lazydocker.tar.gz -C lazydocker-temp
mv lazydocker-temp/lazydocker /usr/local/bin
verify_binary lazydocker
rm -rf lazydocker.tar.gz lazydocker-temp
log "LazyDocker installed successfully."
