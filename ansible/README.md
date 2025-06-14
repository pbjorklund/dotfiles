# Ansible Fedora Setup

Automated Fedora workstation setup with essential development tools and applications.

## Prerequisites

- Fresh Fedora installation
- Internet connection

## Installation

Install Ansible and run the playbook:

```bash
$ sudo dnf install ansible
$ cd ~/dotfiles/ansible
$ ansible-playbook fedora-workstation.ansible.yml
```

## What's Included

**Desktop Apps:** 1Password, Chrome, VS Code, Teams
**Development:** Git, Node.js, Python, Docker, SSH tools
**CLI Tools:** Vim, tmux, ripgrep, fzf, jq, htop

## Post-Installation

1. Add SSH key to GitHub (displayed after playbook completion)
2. Configure 1Password and VS Code
3. Restart session for Docker group membership
