# Dotfiles Repository - LLM Development Instructions

## Project Overview
- **Purpose**: Personal dotfiles and configuration management for development-focused Linux environments
- **Type**: Configuration management system and dotfiles collection
- **Target Users**: Linux developers, system administrators, power users who want reproducible development environments
- **Tech Stack**: Shell scripts (Bash), Lua (Neovim), configuration files (JSON, YAML, conf formats)

## Code Organization
- **Key Directories**:
  - `dotfiles/` - Personal configuration files (.config directories, shell configs)
  - `bin/` - Custom CLI tools (pbproject, llm-link, dev-notify.sh)
  - `project-templates/` - LLM instruction templates and project scaffolding
  - `docs/` - Troubleshooting guides and technical documentation
- **Entry Points**:
  - `dotfiles/install.sh` - Dotfiles symlink installer
  - `bin/pbproject` - Project initialization tool
- **Configuration**:
  - All configs use absolute paths (`/home/pbjorklund/` - needs user customization)
  - Dotfiles are symlinked to proper locations (~/.config/, ~/.*rc files)
- **Dependencies**: No package.json/requirements.txt - minimal dependencies for pure dotfiles

## Development Guidelines
- **Code Style**:
  - Shell scripts use `set -euo pipefail` for error handling
  - Configuration files follow each tool's conventions (JSON for VS Code, conf for terminal apps)
- **Documentation Standards**: Inline comments in complex scripts, README sections for major features
- **Review Process**: Personal repository - changes tested on local system before commit

## Project-Specific Context

### Critical Design Principles
- **Security first**: Public configs contain no credentials - real secrets managed separately
- **Symlink-based**: Dotfiles are symlinked from repo for easy updates
- **Hardcoded paths**: Uses `/home/pbjorklund/` throughout - requires find/replace for new users

### Technology Integrations
- **Desktop Environment**: Primarily Hyprland (Wayland compositor) with GNOME fallback
- **Development Workflow**: Kitty terminal + tmux + Neovim with file watching
- **AI Development Tools**: Unified LLM instruction system supporting Claude Code, OpenCode, GitHub Copilot, Roo, Gemini

### Unique Features
- **dev-notify.sh**: Desktop notifications from AI coding tools (Claude Code, OpenCode)
- **pbproject**: Creates new projects with shared LLM instruction templates
- **llm-link**: Manages AI tool configurations across projects with symlink/detach workflow

### Common Gotchas
- Hardcoded `/home/pbjorklund/` paths need replacement for other users. Try to avoid hardcoding paths in new code. Some tools don't expand `~` properly, hence absolute paths
