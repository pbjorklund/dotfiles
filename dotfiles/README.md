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

## Features

### Bash Configuration

- Extended history (10,000 commands in memory, 20,000 in file)
- Useful aliases: `ll`, `la`, `l`, colorized `grep` and `ls`
- Neovim as default editor
- Disabled pagers for better automation compatibility

### Git Configuration

- Helpful aliases: `co` (checkout), `ci` (commit), `st` (status), `br` (branch)
- Colorized output for better readability
- GitHub credential helper integration

### Tmux Configuration

- Vi-style key bindings in copy mode
- 256 color support
- Activity monitoring
- Automatic window renaming disabled
- Custom color scheme (Solarized-inspired)

### Zellij Configuration

- Custom keybindings with vim-style navigation (hjkl)
- Tmux-compatible bindings for easy migration
- Nord theme for consistent visual appearance
- Wayland clipboard integration (`wl-copy`)
- Clear default mode switching with modal interface
- Floating panes and layout management
- Session management and plugin integration

### Hyprland Configuration

- Multi-monitor setup with custom scaling and positioning
- Custom device sensitivity settings (mouse configuration)
- Application-specific window rules and focus behavior
- Custom keybindings for window management and applications
- Bluetooth management with quick toggle and device control

### Waybar Configuration

- System monitoring modules (CPU, temperature, battery, audio, Bluetooth)
- Hyprland workspace integration
- Modern floating pill design with transparency
- Custom CSS styling with animations and hover effects

### VS Code Configuration

- Ansible Python interpreter configuration
- File formatting rules (trim whitespace, final newlines)
- YAML and Ansible indentation settings (2 spaces)
- Format-on-save enabled for consistent code style

> **Note:** Only `settings.json` is managed. VS Code extensions and other workspace files
> are intentionally excluded to avoid conflicts with personal development setups.

## Customization

To add personal customizations without modifying the main files:

- Create `~/.bash_local` for additional bash configuration
- Create `~/.bash_aliases` for additional aliases

These files will be automatically sourced if they exist.
