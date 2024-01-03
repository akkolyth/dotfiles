sudo apt update && sudo apt upgrade


# Cargo + gitui
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH=~/.cargo/bin:$PATH
cargo install gitui

# Lazydocker
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
mkdir lazydocker-temp
sudo mv lazydocker-temp/lazydocker /usr/local/bin
lazydocker --version
rm -rf lazydocker.tar.gz lazydocker-temp