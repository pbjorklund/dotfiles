# Development Environment

Automated Linux development environment setup with personal dotfiles.

## Quick Start

```bash
git clone https://github.com/pbjorklund/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Complete system setup
ansible-playbook ansible/workstation-setup.ansible.yml

# Dotfiles only
cd dotfiles && ./install.sh
```

## Components

- **[dotfiles/](dotfiles/)** - Personal configuration files
- **[ansible/](ansible/)** - System automation and setup

## Requirements

- Fedora Linux
- sudo access
