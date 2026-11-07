# dotfiles

Bash, Zsh, tmux, and a little Neovim. Layout inspired by [geohot/configuration](https://github.com/geohot/configuration).

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

- `t` opens the tmux picker. `x` then `y` kills the selected session.
- Ctrl+T picks files, Ctrl+R searches history, and Alt+C picks a directory.
- With TPM installed, Ctrl+A then Shift+I installs tmux plugins. Continuum
  saves every minute while attached. Ctrl+A then Ctrl+S saves now, and Ctrl+A
  then Ctrl+R restores the latest snapshot.

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
