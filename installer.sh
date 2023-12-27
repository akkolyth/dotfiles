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

cp -f .zshrc ~/.zshrc
cp -f .p10k.zsh ~/.p10k.zsh
cp -f .tmux.conf ~/.tmux.conf
cp -f alacritty.yml ~/.config/alacritty/alacritty.yml
echo -e "${RED}Note:${NC} Move .bashrc on your own! (or just add exec zsh at the end!)"

# Lazydocker <3  
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
mkdir lazydocker-temp
sudo mv lazydocker-temp/lazydocker /usr/local/bin
lazydocker --version
rm -rf lazydocker.tar.gz lazydocker-temp


echo -e "${GREEN}Installation complete.${NC} Make sure to customize your .bashrc file manually."
echo -e "You may want to restart your terminal to apply the changes."