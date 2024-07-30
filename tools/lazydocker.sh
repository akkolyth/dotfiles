#!/bin/bash

# A simple terminal UI for both docker and docker-compose, written in Go with the gocui library.
# https://github.com/jesseduffield/lazydocker

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Fetching the latest version of LazyDocker..."
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
if [[ -z "$LAZYDOCKER_VERSION" ]]; then
    log "Error: Failed to fetch LazyDocker version."
    exit 1
fi
log "Latest LazyDocker version: v$LAZYDOCKER_VERSION"

log "Downloading LazyDocker v$LAZYDOCKER_VERSION..."
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
if [[ $? -ne 0 ]]; then
    log "Error: Failed to download LazyDocker tarball."
    exit 1
fi
log "Downloaded LazyDocker tarball successfully."

log "Creating temporary directory for extraction..."
mkdir lazydocker-temp
if [[ $? -ne 0 ]]; then
    log "Error: Failed to create temporary directory."
    exit 1
fi

log "Extracting LazyDocker tarball..."
tar -xzf lazydocker.tar.gz -C lazydocker-temp
if [[ $? -ne 0 ]]; then
    log "Error: Failed to extract LazyDocker tarball."
    exit 1
fi
log "Extracted LazyDocker tarball successfully."

log "Moving LazyDocker binary to /usr/local/bin..."
sudo mv lazydocker-temp/lazydocker /usr/local/bin
if [[ $? -ne 0 ]]; then
    log "Error: Failed to move LazyDocker binary."
    exit 1
fi
log "Moved LazyDocker binary successfully."

log "Verifying LazyDocker installation..."
lazydocker --version
if [[ $? -ne 0 ]]; then
    log "Error: LazyDocker installation verification failed."
    exit 1
fi
log "LazyDocker installed and verified successfully."

log "Cleaning up..."
rm -rf lazydocker.tar.gz lazydocker-temp
if [[ $? -ne 0 ]]; then
    log "Error: Cleanup failed."
    exit 1
fi
log "Cleanup completed successfully."

log "LazyDocker installation script completed."
