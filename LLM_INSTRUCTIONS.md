# Dotfiles Repository - LLM Development Instructions

## Project Overview
- **Purpose**: Automated Fedora workstation setup using modular Ansible playbooks and comprehensive dotfiles for development-focused Linux environments
- **Type**: Configuration management system and dotfiles collection
- **Target Users**: Linux developers, system administrators, power users who want reproducible development environments
- **Tech Stack**: Ansible (YAML), Shell scripts (Bash), Lua (Neovim), configuration files (JSON, YAML, conf formats)

## Code Organization
- **Key Directories**:
  - `ansible/` - System automation playbooks (package management, service configuration)
  - `dotfiles/` - Personal configuration files (.config directories, shell configs)
  - `bin/` - Custom CLI tools (pbproject, llm-link, dev-notify.sh)
  - `project-templates/` - LLM instruction templates and project scaffolding
  - `docs/` - Troubleshooting guides and technical documentation
- **Entry Points**:
  - `ansible/workstation-setup.ansible.yml` - Master playbook
  - `dotfiles/install.sh` - Dotfiles symlink installer
  - `bin/pbproject` - Project initialization tool
- **Configuration**:
  - All configs use absolute paths (`/home/pbjorklund/` - needs user customization)
  - Dotfiles are symlinked to proper locations (~/.config/, ~/.*rc files)
  - Ansible configs in ansible.cfg, inventory implied as localhost
- **Dependencies**: No package.json/requirements.txt - dependencies managed by Ansible playbooks

## Development Guidelines
- **Code Style**:
  - Shell scripts use `set -euo pipefail` for error handling
  - Ansible uses descriptive task names and proper YAML formatting
  - Configuration files follow each tool's conventions (JSON for VS Code, conf for terminal apps)
- **Documentation Standards**: Inline comments in complex scripts, README sections for major features
- **Review Process**: Personal repository - changes tested on local system before commit

## Project-Specific Context

### Critical Design Principles
- **Modular by design**: Each Ansible playbook targets specific functionality (desktop, development, hardware)
- **Security first**: Public configs contain no credentials - real secrets managed separately
- **Idempotent automation**: Safe to run repeatedly without breaking existing setups
- **Hardcoded paths**: Uses `/home/pbjorklund/` throughout - requires find/replace for new users

### Technology Integrations
- **Desktop Environment**: Primarily Hyprland (Wayland compositor) with GNOME fallback
- **Development Workflow**: Kitty terminal + tmux + Neovim with file watching
- **AI Development Tools**: Unified LLM instruction system supporting Claude Code, OpenCode, GitHub Copilot, Roo, Gemini
- **Hardware Support**: ThinkPad-specific configurations (fingerprint auth, DisplayLink drivers)

### Unique Features
- **dev-notify.sh**: Desktop notifications from AI coding tools (Claude Code, OpenCode)
- **pbproject**: Creates new projects with shared LLM instruction templates
- **llm-link**: Manages AI tool configurations across projects with symlink/detach workflow
- **Ansible modularity**: Tagged playbooks allow selective installation (security, development, desktop, hardware)

### Common Gotchas
- Hardcoded `/home/pbjorklund/` paths need replacement for other users. Try to avoid hardcoding paths in new code. Some tools don't expand `~` properly, hence absolute paths
