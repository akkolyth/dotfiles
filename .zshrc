typeset -U path PATH
path=("$HOME/.local/bin" "${path[@]}")

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# Ubuntu-style prompt
case "$TERM" in
    xterm-color|*-256color)
        PROMPT='%B%F{green}%n@%m%f%b:%B%F{blue}%~%f%b%(!.#.$) '
        ;;
    *)
        PROMPT='%n@%m:%~%(!.#.$) '
        ;;
esac

dotfiles_zsh_dir=${${(%):-%x}:A:h}/config/zsh
source "$dotfiles_zsh_dir/aliases.zsh"
source "$dotfiles_zsh_dir/fzf.zsh"
source "$dotfiles_zsh_dir/tools.zsh"
unset dotfiles_zsh_dir
