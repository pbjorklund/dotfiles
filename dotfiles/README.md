# Dotfiles

Personal configuration files for development environment.

## Files

- **[`bashrc`](bashrc)** - Bash shell configuration with aliases and environment setup
- **[`gitconfig`](gitconfig)** - Git configuration with helpful aliases
- **[`tmux.conf`](tmux.conf)** - Tmux terminal multiplexer configuration

## Installation

```bash
# From the dotfiles directory
./install.sh
```

This will create symlinks from your home directory to these configuration files:
- `~/.bashrc` → `~/dotfiles/dotfiles/bashrc`
- `~/.gitconfig` → `~/dotfiles/dotfiles/gitconfig`
- `~/.tmux.conf` → `~/dotfiles/dotfiles/tmux.conf`

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

## Customization

To add personal customizations without modifying the main files:
- Create `~/.bash_local` for additional bash configuration
- Create `~/.bash_aliases` for additional aliases

These files will be automatically sourced if they exist.
