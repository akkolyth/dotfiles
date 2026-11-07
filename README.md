# dotfiles

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

## Dotfiles specific

- `t` opens the tmux session picker. Arguments pass through to tmux.
- `lg` runs LazyGit, `ldc` runs LazyDocker, `c` clears the screen, and `e` opens Windows Explorer.
- Ctrl+T picks files with a bat preview.
- In tmux, Ctrl+A then Esc enters vi copy mode. Ctrl+A then `x` closes the pane without confirmation.
- Install the tmux plugins with Ctrl+A then Shift+I to enable automatic session recovery.
