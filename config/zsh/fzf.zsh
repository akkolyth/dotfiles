if ! command -v fzf >/dev/null 2>&1; then
    return 0
fi

if command -v fd >/dev/null 2>&1; then
    : ${FZF_CTRL_T_COMMAND='fd --type f --strip-cwd-prefix'}
    : ${FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix'}
elif command -v fdfind >/dev/null 2>&1; then
    : ${FZF_CTRL_T_COMMAND='fdfind --type f --strip-cwd-prefix'}
    : ${FZF_ALT_C_COMMAND='fdfind --type d --strip-cwd-prefix'}
fi

if command -v bat >/dev/null 2>&1; then
    : ${FZF_CTRL_T_OPTS="--preview 'bat --color=always --paging=never --style=numbers --line-range :300 -- {}'"}
elif command -v batcat >/dev/null 2>&1; then
    : ${FZF_CTRL_T_OPTS="--preview 'batcat --color=always --paging=never --style=numbers --line-range :300 -- {}'"}
fi

# Older Ubuntu packages ship standalone integration scripts.
if fzf_zsh=$(fzf --zsh 2>/dev/null); then
    eval "$fzf_zsh"
else
    for fzf_script in completion.zsh key-bindings.zsh; do
        fzf_script="/usr/share/doc/fzf/examples/$fzf_script"
        [[ -r "$fzf_script" ]] && source "$fzf_script"
    done
fi
unset fzf_zsh fzf_script
