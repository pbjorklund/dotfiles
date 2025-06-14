# Dotfiles

My personal dotfiles configuration including shell setup, git configuration, and Fedora system management.

## Installation

```bash
cd ~/dotfiles
./install.sh
```

This will:

- Backup any existing dotfiles to `~/dotfiles_old/`
- Create symlinks from your home directory to the files in this repo
- Set up Fedora management aliases

## What's Included

### Shell Configuration

- `bashrc` - Bash configuration with Fedora aliases and development environment

### Development Tools

- `gitconfig` - Git aliases and configuration
- `tmux.conf` - Tmux configuration

### System Management

- `ansible/` - Ansible playbook for Fedora system setup
- Built-in aliases for Fedora package management

## Ansible Setup

Use the Ansible playbook to set up a new Fedora system:

```bash
cd ansible
sudo dnf install ansible
ansible-playbook setup-fedora.yml
```

See `ansible/README.md` for more details.
