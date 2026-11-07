# dotfiles

My WSL and Windows setup. Bash, Zsh, tmux, Neovim, and Alacritty.

## WSL

```sh
bash setup_dotfiles.sh          # preview
bash setup_dotfiles.sh --apply  # link or migrate
bash scripts/install-cli-tools.sh
```

After pulling the new layout, rerun the linker to move existing links to the
root files. The linker leaves unrelated configs alone. The CLI installer puts
`gh`, `delta`, and `fd` in `~/.local/bin` on x86-64 Linux. Install `fzf` and
`bat` separately, and run `gh auth login` when needed.

Optional Git pager, once per checkout:

```sh
git config --global --add include.path "$PWD/config/git/delta.gitconfig"
```

## Shortcuts

- `t` → tmux session picker. Arguments go straight to tmux, so `t ls` lists sessions.
- `lg` → LazyGit, `ldc` → LazyDocker, `c` → clear, `e` → Windows Explorer.
- `z` → jump to a directory, `zi` → pick a directory from zoxide history.
- Ctrl+T picks files with a preview, Ctrl+R searches history, and Alt+C picks a directory.

### tmux

- Ctrl+A then `s` opens the session picker. In the picker, `x` then `y` kills the selected session.
- Ctrl+A then Esc enters vi copy mode. `v` selects, `y` copies, and `q` exits.
- Ctrl+A then `v` splits side by side, `h` splits top and bottom, and `x` closes the active pane immediately.
- Alt+arrow keys move between panes. Shift+Left/Right switches windows.
- Ctrl+A then Ctrl+S saves a snapshot, and Ctrl+A then Ctrl+R restores it.
  With TPM installed, Ctrl+A then Shift+I installs plugins. Continuum saves every minute while attached.
- The status bar shows PREFIX and COPY when active, plus clocks for SF, NYC, and Warsaw.

## Windows

From a checkout on the Windows filesystem:

```powershell
.\scripts\install-alacritty.ps1          # preview
.\scripts\install-alacritty.ps1 -Apply   # back up and install
```

Alacritty uses JetBrainsMono Nerd Font and opens WSL in your Linux home.
Drag to copy and use Ctrl+V or Shift+Insert to paste. For the PowerShell
profile, copy `config/windows/Microsoft.PowerShell_profile.ps1` to
`$PROFILE.CurrentUserCurrentHost` after checking for an existing profile.
