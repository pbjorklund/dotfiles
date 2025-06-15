# Ansible Playbooks

Modular Fedora workstation setup automation.

## Quick Start

```bash
# Complete setup (recommended)
ansible-playbook workstation-setup.ansible.yml

# With optional components
ansible-playbook workstation-setup.ansible.yml \
  --extra-vars "configure_dns=true install_displaylink=true configure_nas=true"
```

## Playbooks

### Core Components
- **[`workstation-setup.ansible.yml`](workstation-setup.ansible.yml)** - Master orchestrator
- **[`base-system.ansible.yml`](base-system.ansible.yml)** - Core packages and SSH (run once)
- **[`applications.ansible.yml`](applications.ansible.yml)** - Desktop apps and dev tools
- **[`services.ansible.yml`](services.ansible.yml)** - System service configuration
- **[`personal-config.ansible.yml`](personal-config.ansible.yml)** - Dotfiles and GNOME settings

### Optional Components
- **[`hardware-displaylink.ansible.yml`](hardware-displaylink.ansible.yml)** - DisplayLink drivers
- **[`storage-nas.ansible.yml`](storage-nas.ansible.yml)** - NAS storage mounts
- **[`configure-local-dns.ansible.yml`](configure-local-dns.ansible.yml)** - Local DNS resolution

## Individual Usage

```bash
# Update applications only
ansible-playbook applications.ansible.yml

# Apply personal config changes
ansible-playbook personal-config.ansible.yml

# Install DisplayLink drivers
ansible-playbook hardware-displaylink.ansible.yml

# Configure NAS mounts
ansible-playbook storage-nas.ansible.yml
```

## Benefits

- **Focused responsibility** - Each playbook has a single purpose
- **Selective execution** - Run only what needs updating
- **Reduced risk** - Base system changes separated from app updates
- **Environment flexibility** - Optional components for different setups

## Requirements

- Fedora Linux with sudo access
- Ansible installed (`dnf install ansible`)
