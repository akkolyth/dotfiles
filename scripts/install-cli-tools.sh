#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != Linux || "$(uname -m)" != x86_64 || $EUID == 0 ]]; then
    printf 'Run this as your own user on x86-64 Linux or WSL.\n' >&2
    exit 1
fi

bin_dir="$HOME/.local/bin"
mkdir -p -- "$bin_dir"
work_dir=$(mktemp -d -- "$bin_dir/.dotfiles-download.XXXXXXXX")
trap 'rm -f -- "$work_dir/archive.tar.gz" "$work_dir/gh" "$work_dir/delta" "$work_dir/fd"; rmdir -- "$work_dir"' EXIT

install_release() {
    local tool="$1" url="$2" digest="$3" member="$4"

    curl --fail --silent --show-error --location --retry 2 \
        --output "$work_dir/archive.tar.gz" "$url"
    printf '%s  %s\n' "$digest" "$work_dir/archive.tar.gz" | sha256sum --check --status
    tar -xOzf "$work_dir/archive.tar.gz" -- "$member" > "$work_dir/$tool"
    chmod 755 "$work_dir/$tool"
    "$work_dir/$tool" --version
}

install_release gh \
    https://github.com/cli/cli/releases/download/v2.103.3/gh_2.103.3_linux_amd64.tar.gz \
    4c806978ffce1cec70853302a56d70ac6da4f19bae7adca4e1a8ab00633dd91d \
    gh_2.103.3_linux_amd64/bin/gh
install_release delta \
    https://github.com/dandavison/delta/releases/download/0.20.1/delta-0.20.1-x86_64-unknown-linux-musl.tar.gz \
    69dcb4043f55c29118f408c6efd30115e0a4e0a6709253343b8c8fa814ab4a31 \
    delta-0.20.1-x86_64-unknown-linux-musl/delta
install_release fd \
    https://github.com/sharkdp/fd/releases/download/v10.5.2/fd-v10.5.2-x86_64-unknown-linux-musl.tar.gz \
    7e2d07fa2b8807642aaec67b7e2972a9fbe4db26fcb340a7372392db42b26694 \
    fd-v10.5.2-x86_64-unknown-linux-musl/fd

for tool in gh delta fd; do
    mv -fT -- "$work_dir/$tool" "$bin_dir/$tool"
done
