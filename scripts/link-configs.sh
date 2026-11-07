#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
    '') apply=false ;;
    --apply) apply=true ;;
    *) printf 'Usage: %s [--apply]\n' "$0" >&2; exit 2 ;;
esac
if (( $# > 1 )); then
    printf 'Usage: %s [--apply]\n' "$0" >&2
    exit 2
fi
if (( EUID == 0 )); then
    printf 'Run this script as the user who owns the dotfiles.\n' >&2
    exit 1
fi

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
status=0
for relative_path in bash/.bashrc zsh/.zshrc tmux/.tmux.conf nvim; do
    source_path="$repo_dir/config/$relative_path"
    case "$relative_path" in
        nvim) target="${XDG_CONFIG_HOME:-$HOME/.config}/nvim" ;;
        *) target="$HOME/${relative_path##*/}" ;;
    esac
    replace=()

    if [[ ! -e "$source_path" ]]; then
        printf 'Missing source %s\n' "$source_path" >&2
        status=1
        continue
    fi

    if [[ -L "$target" && "$target" -ef "$source_path" ]]; then
        printf 'Already linked %s\n' "$target"
        continue
    elif [[ -L "$target" && "$(realpath -m -- "$target")" == "$repo_dir/$relative_path" ]]; then
        replace=(-f)
    elif [[ -e "$target" || -L "$target" ]]; then
        printf 'Existing path needs review %s\n' "$target" >&2
        status=1
        continue
    fi

    if "$apply"; then
        mkdir -p -- "$(dirname -- "$target")"
        ln -sT "${replace[@]}" -- "$source_path" "$target"
        printf 'Linked %s -> %s\n' "$target" "$source_path"
    else
        printf 'Would link %s -> %s\n' "$target" "$source_path"
    fi
done
exit "$status"
