# Files to Move to Ansible Playbooks

This directory contains system-level configurations that should be managed by ansible-playbooks rather than dotfiles.

## Contents

### systemd/ (would contain)
- `system/disable-usb-wakeup.service` - System service to prevent USB devices from waking laptop
- `user/` - User systemd services (waybar, waybar-watcher, etc.)

### Scripts (would contain)
- `disable-usb-wakeup.sh` - Script that prevents USB devices from waking the system
- `show-monitor-info.sh` - Monitor information helper script

## Rationale

These files handle system-level configuration that:
- Requires root privileges to install
- Is hardware/laptop specific 
- Should be managed consistently across workstations via ansible
- Doesn't belong in personal dotfiles (which should be user-space only)

## What Was Removed

The following system-level configurations were removed from dotfiles:
- USB wakeup management scripts and services
- Monitor information helper script  
- All systemd service definitions and management
- System-level file installation requiring sudo privileges

## Next Steps

1. Move these configurations to the appropriate ansible-playbooks repository
2. Update playbooks to handle systemd service installation and enabling
3. Remove references from dotfiles install.sh (already done)