#!/bin/bash

set -e

require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
    fi
}

require_root

apt-get update -y
apt-get install -y tmux
tmux -V