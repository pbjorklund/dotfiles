# Development Environment

Automated Fedora workstation setup with modular Ansible playbooks and personal dotfiles.

## Quick Start

```bash
git clone https://github.com/pbjorklund/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Complete workstation setup (recommended)
ansible-playbook ansible/workstation-setup.ansible.yml

# Selective setup using tags
ansible-playbook ansible/workstation-setup.ansible.yml --tags security,development

# Dotfiles only
cd dotfiles && ./install.sh
```

## Components

- **[ansible/](ansible/)** - Modular system automation and setup playbooks
  - Security & authentication (1Password, SSH, GitHub CLI)
  - Development tools (VS Code, containers, CLI utilities)
  - Desktop applications (GNOME, Flatpaks, browsers)
  - Hyprland desktop environment with workspace management
  - SDDM display manager with custom theme
  - Optional components (hardware drivers, NAS, DNS)
- **[dotfiles/](dotfiles/)** - Personal configuration files (bash, git, tmux)
- **[bin/](bin/)** - Custom scripts and utilities
  - `pbproject` - Project initialization tool with symlinked templates
  - `claude-notify.sh` - Universal notification system for Claude Code and OpenCode
  - `tmux-global-indicators.sh` - Enhanced tmux activity/bell monitoring

## Features

- **Modular Architecture**: Focused playbooks for specific areas (security, development, desktop)
- **Selective Execution**: Run only what you need using tags or individual playbooks
- **Idempotent**: Safe to run repeatedly, only applies necessary changes
- **Secure by Default**: SSH-based Git auth, 1Password integration, privacy hardening
- **Modern Desktop**: Hyprland with advanced workspace/monitor management, SDDM with custom theme
- **Development Notifications**: Integrated notification system for Claude Code and OpenCode with mako desktop alerts
- **Hardware Support**: ThinkPad fingerprint auth, DisplayLink drivers

## Requirements

- Fedora Linux with sudo access
- Ansible installed (`dnf install ansible`)
