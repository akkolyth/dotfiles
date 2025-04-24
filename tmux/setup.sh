#!/bin/bash

set -e

[[ $EUID -ne 0 ]] && { echo "Run as root"; exit 1; }

echo "Installing tmux..."
apt-get update -y
apt-get install -y tmux

tmux -V

echo "Done."
