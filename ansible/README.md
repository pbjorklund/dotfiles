# Ansible Playbooks

**CLEAN ARCHITECTURE**: Each playbook has a single, focused responsibility.

## Quick Start

```bash
# Complete setup (recommended)
ansible-playbook workstation-setup.ansible.yml

# With optional components
ansible-playbook workstation-setup.ansible.yml \
  --extra-vars "configure_dns=true install_displaylink=true configure_nas=true configure_fingerprint=true"

# Selective installation using tags
ansible-playbook workstation-setup.ansible.yml --tags security,development
```

## Core Playbooks

### Essential Components

- **[`workstation-setup.ansible.yml`](workstation-setup.ansible.yml)** - Master orchestrator that runs all components
- **[`base-system.ansible.yml`](base-system.ansible.yml)** - Core packages, repositories, SSH, and system prep
- **[`security-authentication.ansible.yml`](security-authentication.ansible.yml)** - 1Password, SSH agent, GitHub CLI, authentication
- **[`development-tools.ansible.yml`](development-tools.ansible.yml)** - Dev tools, CLI utilities, containers, Rust toolchain
- **[`desktop-applications.ansible.yml`](desktop-applications.ansible.yml)** - GNOME utilities, Flatpaks, desktop apps
- **[`services.ansible.yml`](services.ansible.yml)** - System service configuration and startup
- **[`dotfiles.ansible.yml`](dotfiles.ansible.yml)** - Dotfiles repository cloning and deployment
- **[`personal-config.ansible.yml`](personal-config.ansible.yml)** - GNOME settings, user preferences

### Security & Privacy

- **[`firewall-security.ansible.yml`](firewall-security.ansible.yml)** - Firewall, fail2ban, network security
- **[`privacy-hardening.ansible.yml`](privacy-hardening.ansible.yml)** - Privacy tweaks, telemetry disabling
- **[`fingerprint-auth.ansible.yml`](fingerprint-auth.ansible.yml)** - Fingerprint authentication (ThinkPad X1 Carbon)

### Optional Components

- **[`hyprland-desktop.ansible.yml`](hyprland-desktop.ansible.yml)** - Hyprland tiling window manager
- **[`hardware-displaylink.ansible.yml`](hardware-displaylink.ansible.yml)** - DisplayLink drivers for docking stations
- **[`storage-nas.ansible.yml`](storage-nas.ansible.yml)** - NAS storage mounts and CIFS shares
- **[`configure-local-dns.ansible.yml`](configure-local-dns.ansible.yml)** - Local DNS resolution with DNS-over-TLS
- **[`backup-system.ansible.yml`](backup-system.ansible.yml)** - Automated backup configuration
- **[`fonts.ansible.yml`](fonts.ansible.yml)** - Additional fonts and typography

## Individual Playbook Usage

```bash
# Security and authentication only
ansible-playbook security-authentication.ansible.yml

# Development tools only
ansible-playbook development-tools.ansible.yml

# Desktop applications only
ansible-playbook desktop-applications.ansible.yml

# Apply personal config changes
ansible-playbook personal-config.ansible.yml

# Hardware-specific setups
ansible-playbook hardware-displaylink.ansible.yml
ansible-playbook fingerprint-auth.ansible.yml

# Optional components
ansible-playbook storage-nas.ansible.yml
ansible-playbook configure-local-dns.ansible.yml
```

## Tag-Based Execution

Run specific categories using the orchestrator with tags:

```bash
# Security and development tools only
ansible-playbook workstation-setup.ansible.yml --tags security,development

# Base system and desktop apps
ansible-playbook workstation-setup.ansible.yml --tags base,desktop

# All security-related playbooks
ansible-playbook workstation-setup.ansible.yml --tags security,privacy,fingerprint
```

## Benefits

- **Single responsibility** - Each playbook focuses on one area of configuration
- **Selective execution** - Run only what needs updating with tags or individual playbooks
- **Reduced risk** - Critical system changes separated from application installs
- **Environment flexibility** - Optional components for different hardware/usage scenarios
- **Idempotent** - Safe to run repeatedly, only applies necessary changes
- **Modular maintenance** - Easy to update, debug, and extend individual components

## Migration from Legacy

⚠️ The monolithic `applications.ansible.yml` has been deprecated and split into:

- `security-authentication.ansible.yml` (1Password, SSH, GitHub CLI)
- `development-tools.ansible.yml` (VS Code, containers, CLI tools)
- `desktop-applications.ansible.yml` (GNOME, Flatpaks, browsers)

Use `workstation-setup.ansible.yml` instead of the old applications playbook.

## Responsibility Separation

**Ansible handles:**

- System package installation (dnf, flatpak)
- System service configuration
- User creation and permissions
- Repository setup

**`dotfiles/install.sh` handles:**

- Personal configuration file deployment
- Dotfiles symlinking (.bashrc, .gitconfig, etc.)
- .config directory management
- VS Code settings deployment

## After Ansible Setup

```bash
# Install personal configuration files
cd ~/dotfiles && ./dotfiles/install.sh
```

## Requirements

- Fedora Linux with sudo access
- Ansible installed (`dnf install ansible`)
