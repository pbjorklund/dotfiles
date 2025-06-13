# Dotfiles

My personal dotfiles configuration including shell setup, git configuration, and NixOS system management.

## Installation

```bash
cd ~/dotfiles
./install.sh
```

This will:
- Backup any existing dotfiles to `~/dotfiles_old/`
- Create symlinks from your home directory to the files in this repo
- Set up NixOS management aliases

## What's Included

### Shell Configuration
- `bashrc` - Bash configuration with NixOS aliases and development environment

### Development Tools
- `gitconfig` - Git aliases and configuration
- `tmux.conf` - Tmux configuration

### NixOS Configuration
- `nixos/` - Complete NixOS system configuration
- Built-in aliases for NixOS management (nixedit, nixdeploy, nixtest, etc.)

## NixOS Workflow

The bashrc includes these aliases for managing your NixOS configuration:

- `nixedit` - Open NixOS configuration in VS Code
- `nixtest` - Test configuration changes
- `nixdeploy` - Deploy configuration to system
- `nixswitch` - Switch to new configuration
- `nixboot` - Set configuration for next boot
- `nixgc` - Garbage collect old generations
- `nixupdate` - Update and switch to latest packages

See `nixos/README.md` for detailed NixOS workflow.
