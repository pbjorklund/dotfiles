# Dotfiles

Personal dotfiles for shell setup, development tools, and Fedora system management.

## Prerequisites

- Fedora Linux
- Bash shell

## Installation

```bash
$ cd ~/dotfiles
$ ./install.sh
```

Creates symlinks and backs up existing files to `~/dotfiles_old/`.

## What's Included

**Shell:** [`bashrc`](bashrc) with Fedora aliases and development environment
**Development:** [`gitconfig`](gitconfig), [`tmux.conf`](tmux.conf)
**System:** [`ansible/`](ansible/) playbook for automated Fedora setup

## Automated Setup

For new Fedora systems, use the Ansible playbook:

```bash
$ cd ./ansible
$ sudo dnf install ansible
$ ansible-playbook fedora-workstation.ansible.yml
```

See [`ansible/README.md`](ansible/README.md) for details.
