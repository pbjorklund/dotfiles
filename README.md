# Dotfiles

Personal configuration files for Linux development environment with automatic local DNS resolution.

## Features

- **Shell Configuration**: Enhanced bash configuration with useful aliases and environment setup
- **Git Configuration**: Streamlined git settings with helpful aliases
- **Tmux Configuration**: Productive terminal multiplexer setup
- **Local DNS Resolution**: Automatic hostname resolution for local network devices

## Quick Start

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

This will:
1. Install dotfiles (bashrc, gitconfig, tmux.conf)
2. Configure DNS to resolve local hostnames like `knuth` instead of IP addresses

## Installation Options

```bash
# Install everything (dotfiles + DNS configuration)
./install.sh

# Install only dotfiles
./install.sh --dotfiles-only

# Configure only DNS resolution
./install.sh --dns-only

# Show help
./install.sh --help
```

## Local DNS Resolution

The DNS configuration enables you to ping devices by hostname instead of IP address:

```bash
# Instead of this:
ping 192.168.1.35

# You can do this:
ping knuth
```

### How It Works

- **Automatic Router Detection**: Detects your router's IP automatically
- **All Network Interfaces**: Works for WiFi, Ethernet, and other connections
- **No Hardcoded Mappings**: Uses your router's DNS/DHCP for hostname resolution
- **Fallback DNS**: Maintains external DNS resolution with public servers

### Manual DNS Configuration

```bash
# Configure DNS resolution
./scripts/setup-local-dns.sh --configure

# Check current status
./scripts/setup-local-dns.sh --status

# Restore original configuration
./scripts/setup-local-dns.sh --restore
```

### Using Ansible

For automated deployment across multiple systems:

```bash
# Configure DNS using Ansible
ansible-playbook ansible/configure-local-dns.ansible.yml

# Run with verbose output
ansible-playbook ansible/configure-local-dns.ansible.yml -v
```

## File Structure

```
├── bashrc                              # Bash shell configuration
├── gitconfig                           # Git configuration with aliases
├── tmux.conf                           # Tmux configuration
├── install.sh                          # Main installation script
├── scripts/
│   └── setup-local-dns.sh              # DNS configuration script
└── ansible/
    ├── ansible.cfg                     # Ansible configuration
    ├── configure-local-dns.ansible.yml # DNS setup playbook
    └── fedora-workstation.ansible.yml  # Workstation setup playbook
```

## Requirements

- **Operating System**: Linux with systemd-resolved (Ubuntu 18.04+, Fedora 30+, etc.)
- **Network**: Local router with DNS/DHCP services
- **Permissions**: sudo access for DNS configuration

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
