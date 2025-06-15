# Development Environment Setup

Automated setup for Linux development environment with modular Ansible playbooks and personal dotfiles.

## Components

- **[Dotfiles](dotfiles/)**: Personal configuration files (bashrc, gitconfig, tmux.conf)
- **[Ansible Playbooks](ansible/)**: Modular system setup and application installation
- **[Scripts](scripts/)**: Utility scripts for DNS and system configuration

## Quick Start

### Complete Workstation Setup

```bash
git clone https://github.com/pbjorklund/dotfiles.git ~/dotfiles
cd ~/dotfiles
ansible-playbook ansible/workstation-setup.ansible.yml
```

### Dotfiles Only

```bash
git clone https://github.com/pbjorklund/dotfiles.git ~/dotfiles
cd ~/dotfiles/dotfiles
./install.sh
```

## Ansible Playbooks

The Ansible configuration is modular for better maintainability:

```bash
# Complete workstation setup (recommended)
ansible-playbook ansible/workstation-setup.ansible.yml

# With optional components
ansible-playbook ansible/workstation-setup.ansible.yml \
  --extra-vars "configure_dns=true install_displaylink=true configure_nas=true"

# Individual components (can be run separately)
ansible-playbook ansible/base-system.ansible.yml        # Base system packages
ansible-playbook ansible/applications.ansible.yml       # Install/update applications
ansible-playbook ansible/services.ansible.yml           # Configure services
ansible-playbook ansible/personal-config.ansible.yml    # Dotfiles and GNOME settings
ansible-playbook ansible/hardware-displaylink.ansible.yml # DisplayLink drivers
ansible-playbook ansible/storage-nas.ansible.yml        # NAS mounts
ansible-playbook ansible/configure-local-dns.ansible.yml # DNS configuration
```

## Local DNS Resolution

The DNS configuration enables you to ping devices by hostname instead of IP address:

```bash
# Instead of this:
ping 192.168.1.35

# You can do this:
ping knuth
```

### Manual DNS Configuration

```bash
# Configure DNS resolution
./scripts/setup-local-dns.sh --configure

# Check current status
./scripts/setup-local-dns.sh --status

# Restore original configuration
./scripts/setup-local-dns.sh --restore
```

## File Structure

```
├── dotfiles/                           # Personal configuration files
│   ├── README.md                       # Dotfiles documentation
│   ├── bashrc                          # Bash shell configuration
│   ├── gitconfig                       # Git configuration with aliases
│   ├── tmux.conf                       # Tmux terminal multiplexer configuration
│   └── install.sh                      # Dotfiles installation script
├── scripts/
│   └── setup-local-dns.sh              # DNS configuration script
└── ansible/                            # Automated system setup
    ├── ansible.cfg                     # Ansible configuration
    ├── workstation-setup.ansible.yml   # Master orchestration playbook
    ├── base-system.ansible.yml         # Core system packages and SSH
    ├── applications.ansible.yml        # Desktop apps and development tools
    ├── services.ansible.yml            # System service configuration
    ├── personal-config.ansible.yml     # Dotfiles and GNOME settings
    ├── hardware-displaylink.ansible.yml # DisplayLink driver installation
    ├── storage-nas.ansible.yml         # NAS storage configuration
    └── configure-local-dns.ansible.yml # DNS setup playbook
```

## Requirements

- **Operating System**: Linux with systemd-resolved (Ubuntu 18.04+, Fedora 30+, etc.)
- **Network**: Local router with DNS/DHCP services
- **Permissions**: sudo access for system configuration

## Troubleshooting

### DNS Resolution Not Working

1. Check if systemd-resolved is running:
   ```bash
   systemctl status systemd-resolved
   ```

2. Verify router detection:
   ```bash
   ./scripts/setup-local-dns.sh --status
   ```

3. Test DNS resolution:
   ```bash
   resolvectl query knuth
   dig @192.168.1.1 knuth
   ```

### Router Not Detected

If router auto-detection fails:
```bash
# Check default route
ip route | grep default

# Manually verify router IP
ping 192.168.1.1
```

### Restore Original Configuration

If you need to revert changes:
```bash
./scripts/setup-local-dns.sh --restore
```

## Configuration Details

### DNS Configuration

The system is configured to:
- Use router as primary DNS server
- Fall back to Cloudflare (1.1.1.1) and Google (8.8.8.8)
- Search local domains (.local, .lan, .home)
- Enable LLMNR for Windows/Linux interoperability
- Enable mDNS for macOS/Linux interoperability
- Cache DNS results for performance

### Supported Network Types

- WiFi networks
- Ethernet connections
- VPN connections (when local DNS is accessible)
- Docker bridge networks (isolated)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes following the existing patterns
4. Test on a clean system
5. Submit a pull request

## License

MIT License - see LICENSE file for details.
