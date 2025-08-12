# Dotfiles

Personal configuration files for development environment.

## Files

- **[`bashrc`](bashrc)** - Bash shell configuration with aliases and environment setup
- **[`gitconfig`](gitconfig)** - Git configuration with helpful aliases
- **[`tmux.conf`](tmux.conf)** - Tmux terminal multiplexer configuration
- **[`inputrc`](inputrc)** - GNU Readline configuration for enhanced bash input
- **[`.config/hypr/hyprland.conf`](.config/hypr/hyprland.conf)** - Hyprland wayland compositor configuration
- **[`.config/waybar/config.jsonc`](.config/waybar/config.jsonc)** - Waybar status bar configuration
- **[`.config/waybar/style.css`](.config/waybar/style.css)** - Waybar CSS styling
- **[`.config/zellij/config.kdl`](.config/zellij/config.kdl)** - Zellij terminal multiplexer configuration
- **[`.config/Code/User/settings.json`](.config/Code/User/settings.json)** - VS Code user settings and preferences

## Installation

```bash
# From the dotfiles directory
./install.sh
```

This will create symlinks from your home directory to these configuration files:

- `~/.bashrc` → `~/dotfiles/dotfiles/bashrc`
- `~/.gitconfig` → `~/dotfiles/dotfiles/gitconfig`
- `~/.tmux.conf` → `~/dotfiles/dotfiles/tmux.conf`
- `~/.inputrc` → `~/dotfiles/dotfiles/inputrc`
- `~/.config/hypr/` → `~/dotfiles/dotfiles/.config/hypr/`
- `~/.config/waybar/` → `~/dotfiles/dotfiles/.config/waybar/`
- `~/.config/zellij/` → `~/dotfiles/dotfiles/.config/zellij/`
- `~/.config/Code/User/settings.json` → `~/dotfiles/dotfiles/.config/Code/User/settings.json`

> **Note:** Existing configuration files are backed up to `/tmp/dotfiles-backup-YYYYMMDD-HHMMSS/`
> before being replaced with symlinks.

## Customization

To add personal customizations without modifying the main files:

- Create `~/.bash_local` for additional bash configuration
- Create `~/.bash_aliases` for additional aliases

These files will be automatically sourced if they exist.
