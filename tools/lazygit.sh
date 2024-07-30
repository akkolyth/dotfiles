#!/bin/bash

# A simple terminal UI for git commands
# https://github.com/jesseduffield/lazygit


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Fetching the latest version of LazyGit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
if [[ -z "$LAZYGIT_VERSION" ]]; then
    log "Error: Failed to fetch LazyGit version."
    exit 1
fi
log "Latest LazyGit version: v$LAZYGIT_VERSION"

log "Downloading LazyGit v$LAZYGIT_VERSION..."
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
if [[ $? -ne 0 ]]; then
    log "Error: Failed to download LazyGit tarball."
    exit 1
fi
log "Downloaded LazyGit tarball successfully."

log "Extracting LazyGit tarball..."
tar xf lazygit.tar.gz lazygit
if [[ $? -ne 0 ]]; then
    log "Error: Failed to extract LazyGit tarball."
    exit 1
fi
log "Extracted LazyGit tarball successfully."

log "Installing LazyGit binary to /usr/local/bin..."
install lazygit /usr/local/bin
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install LazyGit binary."
    exit 1
fi
log "Installed LazyGit binary successfully."

log "Verifying LazyGit installation..."
lazygit --version
if [[ $? -ne 0 ]]; then
    log "Error: LazyGit installation verification failed."
    exit 1
fi
log "LazyGit installed and verified successfully."

log "Cleaning up..."
rm -rf lazygit.tar.gz lazygit
if [[ $? -ne 0 ]]; then
    log "Error: Cleanup failed."
    exit 1
fi
log "Cleanup completed successfully."

log "LazyGit installation script completed."
