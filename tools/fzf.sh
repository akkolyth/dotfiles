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
apt-get update && apt-get install -y fzf
verify_binary fzf
