# dotfiles

My shell, tmux, Neovim, and terminal configuration for a Windows + WSL workflow. The Linux configuration lives in this checkout and is linked into my home directory; the Windows configuration is installed separately.

These are personal settings. Review them before applying them, especially [`.bashrc`](.bashrc), which starts Zsh for interactive Bash sessions.

## Linux and WSL setup

Start with Git, Bash, Zsh, tmux, and Neovim installed. The linker uses GNU `ln` and `realpath`, as provided by a typical Linux or WSL distribution. It links configuration files only; it does not install packages or change your login shell.

Clone the repository somewhere you intend to keep it:

```sh
git clone https://github.com/akkolyth/dotfiles.git
cd dotfiles
bash setup_dotfiles.sh
```

The first run previews the links. Review the output, then apply them as your own user:

```sh
bash setup_dotfiles.sh --apply
```

The script links `.bashrc`, `.zshrc`, and `.tmux.conf` into `$HOME`, and `config/nvim` into `${XDG_CONFIG_HOME:-$HOME/.config}/nvim`. Keep the checkout in place so those links continue to work.

Existing files and unrelated symlinks are left in place and reported for review. Back up and move any conflicting configuration yourself, then rerun the script. Links from this checkout's older directory layout are migrated automatically. After pulling updates, rerun the preview to check whether any links need refreshing.

### CLI tools and shell integrations

The optional installer downloads pinned releases of GitHub CLI (`gh`), Git Delta (`delta`), and `fd`, verifies their SHA-256 checksums, and installs them into `~/.local/bin`:

```sh
bash scripts/install-cli-tools.sh
```

It requires x86-64 Linux or WSL, `curl`, `tar`, and `sha256sum`. Run it as your own user; existing binaries with those names in `~/.local/bin` are replaced. The Zsh configuration adds that directory to `PATH`. Run `gh auth login` separately when you need GitHub authentication.

Install `fzf` and `bat` separately for the file picker and previews. The configuration also recognizes the Debian/Ubuntu names `fdfind` and `batcat`. Zoxide and NVM are loaded when available. The `lg` and `ldc` aliases require separate installations of LazyGit and LazyDocker.

Oh My Zsh is optional. If present, the configuration requests its `git`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, and `you-should-use` plugins; install the external plugins separately.

To use Delta as your Git pager, run this once from the checkout:

```sh
git config --global --add include.path "$PWD/config/git/delta.gitconfig"
```

### tmux plugins

The tmux configuration loads TPM from `~/.tmux/plugins/tpm` and uses tmux-sensible, tmux-resurrect, and tmux-continuum. If TPM is not installed:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start tmux and press **Ctrl+A**, then **Shift+I**, to install the configured plugins. Continuum is configured to save sessions every minute and restore them automatically.

## Windows setup

Install Alacritty and JetBrainsMono Nerd Font separately. From a checkout on the Windows filesystem, preview the Alacritty configuration install:

```powershell
.\scripts\install-alacritty.ps1
```

Then apply it:

```powershell
.\scripts\install-alacritty.ps1 -Apply
```

The script copies [`alacritty.toml`](config/alacritty/alacritty.toml) to `%APPDATA%\alacritty\alacritty.toml`, backing up an existing configuration before replacing it. The configuration opens WSL in your Linux home directory, copies selected text to the clipboard, and binds **Ctrl+V** and **Shift+Insert** to paste.

The optional [PowerShell profile](config/windows/Microsoft.PowerShell_profile.ps1) adds menu completion and history search through PSReadLine. Review your existing `$PROFILE.CurrentUserCurrentHost` before copying or merging it.

## Everyday shortcuts

| Shortcut | Action |
| --- | --- |
| `t` | Open the tmux session picker; arguments pass through to tmux. |
| `lg`, `ldc` | Launch LazyGit or LazyDocker. |
| `c` | Clear the terminal. |
| `e` | Open Windows Explorer, when `explorer.exe` is available. |
| Ctrl+T | Pick files with fzf; show previews when bat is installed. |
| Ctrl+A, then Esc | Enter tmux's vi copy mode. |
| Ctrl+A, then `v` or `-` | Split the tmux pane horizontally or vertically. |
| Ctrl+A, then `x` | Close the current pane without confirmation. |

## Repository layout

- [Root dotfiles](.zshrc): Bash, Zsh, and tmux entry points.
- [`config/zsh/`](config/zsh/): aliases, fzf integration, and optional tool setup.
- [`config/nvim/`](config/nvim/): a small Neovim configuration with two-space indentation and line numbers.
- [`config/git/`](config/git/): the optional Delta pager configuration.
- [`config/alacritty/`](config/alacritty/): terminal settings; the Windows installer uses the TOML file.
- [`config/windows/`](config/windows/): the PowerShell profile.
- [`scripts/`](scripts/): configuration linking and optional installers.
