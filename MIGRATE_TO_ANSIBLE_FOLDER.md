# Documentation to Migrate to ansible-fedora Project

This file contains documentation sections that were removed from the dotfiles project and should be moved to the README.md in the ansible-fedora project at ~/Projects/ansible-fedora.

## From README.md - Description Update

OLD:
```
Automated Fedora workstation setup using modular Ansible playbooks and dotfiles. **This is a personal configuration** - fork and adapt to your needs.
```

NEW for dotfiles README:
```
Personal dotfiles for Linux development environments. Focused on terminal workflows with Kitty + tmux + Neovim and AI coding tools integration.
```

## From README.md - Quick Start Section (Ansible Parts)

```bash
# Full automated setup (recommended for new systems)
ansible-playbook ansible/fedora/workstation-setup.ansible.yml

# Selective setup - common tag combinations:
ansible-playbook ansible/fedora/workstation-setup.ansible.yml --tags security,development
ansible-playbook ansible/fedora/workstation-setup.ansible.yml --tags desktop,privacy
```

## From README.md - What This Provides Section (System Parts)

**Core System** (`security`, `base`)
- SSH key management, 1Password CLI, GitHub authentication
- Essential development tools and system hardening

**Desktop Environment** (`desktop`, `hyprland`)
- Hyprland with custom workspace management or GNOME fallback
- SDDM display manager, styled consistently with terminal theme
- Application suite, browser configuration

**Hardware Support** (`hardware`)
- ThinkPad fingerprint authentication setup (complex, now automated)
- DisplayLink drivers configuration (notoriously difficult, now documented)
- Power management and device-specific optimizations

## From README.md - File Structure Section (Ansible Parts)

```
ansible/                    # System automation - run these to set up your machine
├── workstation-setup.yml   # Master playbook that runs everything
├── base-system.yml         # Core packages, users, basic config
├── development-tools.yml   # Languages, editors, containers
├── hyprland-desktop.yml    # Wayland desktop environment
└── hardware-*.yml          # Device-specific stuff (fingerprint, displaylink)
```

## From README.md - Why Ansible Section

**Why Ansible**: Documents complex setup procedures (DisplayLink drivers, fingerprint auth, hardware quirks) that would otherwise require hours of research and trial-and-error.

## From README.md - Requirements Section (Ansible Parts)

- Fedora Linux with sudo access
- Ansible (`dnf install ansible`)
- Internet connection for package downloads
- Some patience for first run (takes 10-15 minutes)

## From LLM_INSTRUCTIONS.md - Project Overview Update

OLD:
```
- **Purpose**: Automated Fedora workstation setup using modular Ansible playbooks and comprehensive dotfiles for development-focused Linux environments
```

NEW for dotfiles:
```
- **Purpose**: Personal dotfiles and configuration management for development-focused Linux environments
```

## From LLM_INSTRUCTIONS.md - Code Organization (Ansible Parts)

```
- `ansible/` - System automation playbooks (package management, service configuration)
```

## From LLM_INSTRUCTIONS.md - Entry Points (Ansible Parts)

```
- `ansible/fedora/workstation-setup.ansible.yml` - Master playbook
```

## From LLM_INSTRUCTIONS.md - Configuration (Ansible Parts)

```
- Ansible configs in ansible.cfg, inventory implied as localhost
```

## From LLM_INSTRUCTIONS.md - Dependencies (Ansible Parts)

```
- Dependencies managed by Ansible playbooks
```

## From LLM_INSTRUCTIONS.md - Technology Integrations (Ansible Parts)

```
- **Hardware Support**: ThinkPad-specific configurations (fingerprint auth, DisplayLink drivers)
```

## From LLM_INSTRUCTIONS.md - Unique Features (Ansible Parts)

```
- **Ansible modularity**: Tagged playbooks allow selective installation (security, development, desktop, hardware)
```

## From docs/Bluetooth-Management.md - Ansible Commands

```bash
cd ansible
ansible-playbook hyprland-desktop.ansible.yml

# OR specific bluetooth setup
ansible-playbook bluetooth-hyprland.ansible.yml
```

## Shell Aliases to Remove

From bashrc/zshrc:
```bash
alias ap='ansible-playbook'
alias apc='ansible-playbook --check'
alias apv='ansible-playbook -v'
```

## Important Note for ansible-fedora Project

The ansible-fedora project should be updated to:
1. Include all the above documentation in its README.md
2. Update any hardcoded paths from `/home/pbjorklund/dotfiles/ansible/` to the new project structure
3. Ensure the project works independently without requiring the dotfiles repo