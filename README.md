# Le Dotfiles

**pbjorklund's personal dotfiles** for Linux development environments. Focused on terminal workflows with Hyprland + Kitty + tmux + Neovim and comprehensive AI coding tools integration.

> [!IMPORTANT]
> **This is a personal configuration** - fork and adapt to your needs. After installation, search/replace hardcoded `/home/pbjorklund/` paths with your username. Many tools don't expand `~` properly so we use absolute paths.

## Philosophy: Application-Centric Organization

Unlike GNU Stow's filesystem mirroring approach, this dotfiles system organizes by **application**, not destination path. Each directory in `dotfiles/` represents a single application's configuration, regardless of where it gets symlinked.

**Examples:**
- `dotfiles/hypr/` → `~/.config/hypr/` (symlinked)
- `dotfiles/git/gitconfig` → `~/.gitconfig` (symlinked)
- `dotfiles/systemd/system/` → `/etc/systemd/system/` (copied with sudo, symlinks not possible)

This makes it easier to understand what each application provides and maintain configurations as cohesive units.

## LLM Instructions Architecture

This repository includes two types of LLM instruction files:

**Project-Specific Instructions** (`LLM_INSTRUCTIONS.md`):
- Context about THIS dotfiles repository
- Development guidelines for working on these configs
- Project structure and conventions

**Global Template Instructions** (`templates/GLOBAL_LLM_INSTRUCTIONS.md`):
- Generic coding guidelines that apply to any project
- Deployed to `~/.config/opencode/`, `~/.claude/`, etc. during installation
- Combined with project-specific instructions by AI tools (YMMV as tools evolve)

The install script merges these appropriately for each AI tool's expected format.

## Quick Start

```bash
git clone https://github.com/pbjorklund/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

> **System automation**: See [machine-setup](https://github.com/pbjorklund/machine-setup) for automated Fedora workstation provisioning.

## My Development Workflow

**Primary Setup**: CLI-first development
- Hyprland (Wayland compositor) with multi-monitor workspace management
- Kitty terminal + tmux with custom styling and activity indicators
- Neovim with file-watching auto-reload for AI tool integration
- Claude Code → OpenCode workflow (usage ceiling management)

**Secondary Setup**: GUI when needed
- VS Code with Roo/Cline/GitHub Copilot integration
- Consistent dark theme across terminal and GUI tools

## Key Features

**AI Development Integration**
- Unified instruction system for Claude Code, OpenCode, GitHub Copilot, Roo, Gemini
- Desktop notifications for AI task completion (requires `dev-notify.sh` from machine-setup/machines/laptop-fedora/bin/)
- Neovim auto-reloads when external AI tools modify files

**Hyprland Workspace Management**
- Workspaces follow monitors (workspace 1 always on primary display)
- Scripts for moving workspaces between monitors
- Keybinds for common window management tasks

**Terminal Workflow Optimization**
- tmux with mouse support and scripting capabilities
- Kitty with proper font rendering and graphics support
- mako for Wayland desktop notifications

## Supported Applications

**Desktop Environment:**
- `hypr/` - Hyprland compositor configuration and scripts
- `waybar/` - Status bar with custom styling
- `mako/` - Notification daemon
- `wofi/` - Application launcher

**Development Tools:**
- `nvim/` - Neovim configuration with LSP and plugins
- `tmux/` - Terminal multiplexer with custom theme
- `terminal/kitty/` - Terminal emulator configuration
- `git/` - Git configuration and aliases

**AI Coding Tools:**
- `opencode/` - CLI coding assistant configuration
- `claude/` - Claude Desktop settings
- `.github/` - GitHub Copilot instructions
- `.roo/` - Roo AI pair programming rules

**System Integration:**
- `systemd/` - User and system service definitions
- `shell/` - Bash/Zsh configuration and aliases

## Why These Choices

- **Hyprland over i3/sway**: Better multi-monitor support, active development, Wayland-native
- **tmux over screen/zellij**: Superior scripting, mouse support, extensive feature set (also: grumpy old man syndrome)
- **Neovim over vim**: Lua configuration, built-in LSP, modern plugin ecosystem
- **Kitty over alacritty**: Better font rendering, graphics protocol support
- **Application-centric organization**: Easier maintenance than filesystem mirroring

## TODO

- [ ] Use `dev-notify` from $PATH instead of hardcoded machine-setup paths