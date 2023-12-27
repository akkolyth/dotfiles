#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

sudo apt update && sudo apt upgrade

sudo add-apt-repository ppa:aslatter/ppa

# General
sudo apt -y install \
    zsh \
    tmux \
    alacritty

pip install thefuck

cp -f .zsh/.zshrc ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cp -f .zsh/.p10k.zsh ~/.p10k.zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp -f .tmux.conf ~/.tmux.conf

mkdir -p ~/.config/alacritty/
cp -f .terminal/alacritty.yml ~/.config/alacritty/alacritty.yml

echo -e "${RED}Note:${NC} Move .bashrc on your own! (or just add exec zsh at the end!)"
echo -e "${GREEN}Installation complete.${NC} Make sure to customize your .bashrc file manually."
echo -e "You may want to restart your terminal to apply the changes."