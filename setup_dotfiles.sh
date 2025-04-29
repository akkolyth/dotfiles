#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

log() {
    echo -e "${BOLD}$(date '+%Y-%m-%d %H:%M:%S') - $1${RESET}"
}

is_windows() {
    grep -qi "microsoft" /proc/version &> /dev/null
}

install() {
    local script_path="$1"

    if [[ ! -f "$script_path" ]]; then
        echo -e "${BOLD}${RED}Error: $script_path not found.${RESET}"
        summary+=("$script_path: ${BOLD}${RED}Missing${RESET}")
        log "Aborting due to missing script."
        summary
        exit 1
    fi

    log "Installing $script_path..."
    bash "$script_path"
    if [[ $? -ne 0 ]]; then
        echo -e "${BOLD}${RED}Error: $script_path failed.${RESET}"
        summary+=("$script_path: ${BOLD}${RED}Failed${RESET}")
        log "Aborting due to failed installation."
        summary
        exit 1
    else
        echo -e "${BOLD}${GREEN}$script_path installed.${RESET}"
        summary+=("$script_path: ${BOLD}${GREEN}OK${RESET}")
    fi
}

summary() {
    log "Installation Summary:"
    for item in "${summary[@]}"; do
        echo -e "$item"
    done
}

stw() {
    local source_path="$1"
    local target_dir="$2"

    if [[ -z "$source_path" || -z "$target_dir" ]]; then
        echo -e "${RED}Error: Source path and target directory must be provided.${RESET}"
        exit 1
    fi

    target_dir="${target_dir/#\~/$HOME}"

    if [[ ! -e "$source_path" ]]; then
        echo -e "${RED}Error: $source_path does not exist.${RESET}"
        exit 1
    fi

    mkdir -p "$target_dir"

    if [[ -d "$source_path" ]]; then
        for item in "$source_path"/*; do
            local filename
            filename=$(basename "$item")
            local target="$target_dir/$filename"

            if [[ -e "$target" && ! -L "$target" ]]; then
                mv "$target" "$target.bak"
                echo "Backed up existing $filename to $filename.bak in $target_dir"
            fi

            ln -sf "$(realpath "$item")" "$target"
            echo "Linked $filename → $target"
            summary+=("Stow $filename: ${GREEN}OK${RESET}")
        done
    else
        local filename
        filename=$(basename "$source_path")
        local target="$target_dir/$filename"

        if [[ -e "$target" && ! -L "$target" ]]; then
            mv "$target" "$target.bak"
            echo "Backed up existing $filename to $filename.bak in $target_dir"
        fi

        ln -sf "$(realpath "$source_path")" "$target"
        echo "Linked $filename → $target"
        summary+=("Stow $filename: ${GREEN}OK${RESET}")
    fi
}

echo -e "${BOLD}${RED}WARNING:${RESET} This will overwrite your dotfiles."
echo -e "${BOLD}${BLUE}Target:${RESET} $HOME"
read -p "Continue? (yes/no): " confirm
[[ "$confirm" != "yes" ]] && { echo -e "${RED}Aborted.${RESET}"; exit 0; }

[[ $EUID -ne 0 ]] && { echo -e "${RED}Run as root.${RESET}"; exit 1; }

summary=()

log "Installing dependencies..."
apt-get update && apt-get install -y stow

log "Checking WSL..."
if is_windows; then
    summary+=("alacritty: ${BLUE}Skipped (WSL)${RESET}")
else
    install "./terminal/alacritty.sh"
fi

install "./zsh/setup.sh"
install "./tmux/setup.sh"
install "./tools/fzf.sh"
install "./tools/lazydocker.sh"
install "./tools/lazygit.sh"
install "./docker/setup.sh"
install "./bash/setup_bash_profile.sh"

stw bash/.bashrc ~
stw zsh/.zshrc ~
stw tmux/.tmux.conf ~ 
# stw nvim ~/.config/nvim

summary
