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
    # Check if running on WSL (Windows Subsystem for Linux)
    if grep -q -i "microsoft" /proc/version &> /dev/null; then
        return 0
    fi
    return 1
}

run_install_script() {
    local script_path="$1"
    local tool_name=$(basename "$script_path" .sh)

    if [[ ! -f "$script_path" ]]; then
        echo -e "${BOLD}${RED}Warning: $script_path does not exist.${RESET}"
        summary+=("$tool_name: ${BOLD}${RED}File not found${RESET}")
        if [[ "$2" == "critical" ]]; then
            log "Critical error encountered. Stopping installation."
            print_summary
            exit 1
        fi
        return
    fi

    log "Installing $tool_name..."
    bash "$script_path"
    if [[ $? -ne 0 ]]; then
        echo -e "${BOLD}${RED}Error: $tool_name installation failed.${RESET}"
        summary+=("$tool_name: ${BOLD}${RED}Error${RESET}")
        if [[ "$2" == "critical" ]]; then
            log "Critical error encountered. Stopping installation."
            print_summary
            exit 1
        fi
    else
        echo -e "${BOLD}${GREEN}$tool_name installed successfully.${RESET}"
        summary+=("$tool_name: ${BOLD}${GREEN}Success${RESET}")
    fi
}

print_summary() {
    log "Installation Summary:"
    for summary_item in "${summary[@]}"; do
        echo -e "$summary_item"
    done
}

stow_dotfiles() {
    log "Stowing dotfiles..."

    directories=("bash_cfg" "tmux_cfg" "zsh_cfg")

    for dir in "${directories[@]}"; do
        if [[ -d "$dir" ]]; then
            for file in $(ls -A "$dir"); do
                if [[ "$file" == *.sh ]]; then
                    echo "Skipping $file (shell script)"
                    continue
                fi

                target="$HOME/$file"
                if [[ -e "$target" && ! -L "$target" ]]; then
                    if [[ "$(stow --simulate --target="${HOME}" "$dir" 2>&1 | grep "$file")" ]]; then
                        mv "$target" "$target.bak"
                        echo "Backed up $file to $file.bak"
                    fi
                fi
            done

            stow -v --target="${HOME}" "$dir"
            if [[ $? -ne 0 ]]; then
                echo -e "${BOLD}${RED}Error: Stowing $dir failed.${RESET}"
                summary+=("Stowing $dir: ${BOLD}${RED}Error${RESET}")
                log "Critical error encountered. Stopping installation."
                print_summary
                exit 1
            else
                echo -e "${BOLD}${GREEN}Stowed $dir successfully.${RESET}"
                summary+=("Stowing $dir: ${BOLD}${GREEN}Success${RESET}")
            fi
        else
            echo -e "${BOLD}${RED}Warning: Directory $dir does not exist.${RESET}"
        fi
    done
}

echo -e "${BOLD}${RED}WARNING:${RESET} This script will remove your current dotfiles and replace them with new ones."
echo -e "${BOLD}${BLUE}Home directory:${RESET} $HOME"
read -p "Do you want to continue? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
    echo -e "${BOLD}${RED}Installation aborted.${RESET}"
    exit 0
fi

if [[ $EUID -ne 0 ]]; then
    echo -e "${BOLD}${RED}This script must be run as root${RESET}"
    exit 1
fi

summary=()

log "Installing GNU Stow..."
sudo apt-get install -y stow
if [[ $? -ne 0 ]]; then
    log "Error: Failed to install GNU Stow."
    exit 1
else
    echo -e "${BOLD}${GREEN}GNU Stow installed successfully.${RESET}"
    summary+=("GNU Stow: ${BOLD}${GREEN}Success${RESET}")
fi

log "Fetching package information..."
sudo apt-get update
if [[ $? -ne 0 ]]; then
    log "Error: Failed to update package information."
    exit 1
fi

# Check if running on Windows (WSL)
if is_windows; then
    log "Running on Windows (WSL). Skipping alacritty installation."
    summary+=("alacritty: ${BOLD}${BLUE}Skipped${RESET}")
else
    log "Installing terminal tools..."
    run_install_script "./terminal/alacritty.sh"
fi

log "Installing terminal tools..."
run_install_script "./tmux/tmux.sh"

log "Checking and installing zsh components..."
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    rm -rf "$HOME/.oh-my-zsh"
    echo "Deleted $HOME/.oh-my-zsh"
fi

run_install_script "./zsh/zsh.sh" "critical"
run_install_script "./zsh/oh-my-zsh.sh" "critical"
run_install_script "./zsh/zsh-plugins.sh"
run_install_script "./zsh/starship.sh"

log "Installing additional tools..."
for tool_script in ./tools/*.sh; do
    run_install_script "$tool_script"
done

stow_dotfiles

print_summary
