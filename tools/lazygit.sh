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
log "Installing LazyGit..."
VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
verify_binary lazygit
rm -f lazygit.tar.gz lazygit
log "LazyGit installed successfully."
