# Keep user-installed tools available once, even when reloading this file.
typeset -U path PATH
path=("$HOME/.local/bin" "${path[@]}")

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

dotfiles_zsh_dir=${${(%):-%x}:A:h}
source "$dotfiles_zsh_dir/aliases.zsh"
source "$dotfiles_zsh_dir/fzf.zsh"
source "$dotfiles_zsh_dir/tools.zsh"
unset dotfiles_zsh_dir
