function t {
    if (( $# )); then
        tmux "$@"
    elif [[ -n "$TMUX" ]]; then
        tmux choose-tree -s
    elif tmux has-session 2>/dev/null; then
        tmux attach-session \; choose-tree -s
    else
        tmux new-session \; choose-tree -s
    fi
}

alias c='clear'
alias lg='lazygit'
alias ldc='lazydocker'

if command -v explorer.exe >/dev/null 2>&1; then
    alias e='explorer.exe'
fi
