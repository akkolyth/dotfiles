# Dotfiles

Personal shell and terminal configuration for Ubuntu on WSL and Windows PowerShell.

| Path | Purpose |
| --- | --- |
| `config/bash/`, `config/zsh/`, `config/tmux/` | Live WSL dotfiles |
| `config/git/delta.gitconfig` | Optional Delta pager settings |
| `config/windows/` | Native PowerShell console profile |
| `config/alacritty/` | Standalone Linux terminal config |
| `scripts/link-configs.sh` | Preview or apply Bash, Zsh, and tmux links |
| `scripts/install-cli-tools.sh` | Install pinned GitHub CLI, Delta, and fd releases |

## WSL setup

From the repository root, run these commands as your own user.

```sh
bash scripts/link-configs.sh
bash scripts/link-configs.sh --apply
bash scripts/install-cli-tools.sh
```

The linker creates missing links and migrates links that still point to the old
layout in this checkout. Other existing paths require manual review.
`setup_dotfiles.sh` is also available as a shortcut to the linker.

The CLI installer targets x86-64 Linux and WSL, verifies the release archives
against pinned SHA-256 hashes, and installs into `~/.local/bin`. Install fzf and
bat through your distro package manager if needed. On Ubuntu, the bat package
provides the `batcat` command.

To use Delta for Git diffs, include its config once from your WSL Git config.

```sh
git config --global --add include.path "$HOME/.dotfiles/config/git/delta.gitconfig"
```

Sign in to GitHub when ready with `gh auth login`.

## Zsh shortcuts

- **Ctrl+T** picks files with a bat preview. **Alt+C** jumps to a directory.
- **Ctrl+R** searches command history.
- `z` jumps to a recently or frequently used directory. `zi` opens an interactive picker.
- `t` opens the tmux session picker. Select a session row and press `x` to
  kill it, then confirm with `y`. Arguments such as `t ls` are passed to tmux.
- `c`, `lg`, `ldc`, and `e` are defined in `config/zsh/aliases.zsh`.

## tmux session recovery

With TPM installed, press Ctrl+A then Shift+I to install the listed plugins.
Continuum checks for a snapshot every minute while an attached tmux client
refreshes the status bar. It restores the latest snapshot when the tmux server
starts. Press Ctrl+A then Ctrl+S to save immediately or Ctrl+A then Ctrl+R
to restore manually.

## Alacritty on Windows

Add the bindings in `config/alacritty/clipboard.windows.toml` to your
`%APPDATA%/alacritty/alacritty.toml`. Ctrl+V and Shift+Insert paste from
the Windows clipboard in normal terminal mode. Drag to select and copy text
without holding Shift. In WSL, tmux also sends mouse selections and vi-mode
yanks to the Windows clipboard through `clip.exe`.

## Windows PowerShell

Copy `config/windows/Microsoft.PowerShell_profile.ps1` to
`$PROFILE.CurrentUserCurrentHost` in the PowerShell edition you use. Review
any existing profile before copying. Tab opens a completion menu and the arrow
keys search history by prefix.

Keep credentials, history, and machine-specific settings outside the repository.
