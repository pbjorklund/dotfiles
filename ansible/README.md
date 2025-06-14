# Ansible Fedora Setup

This directory contains an Ansible playbook for setting up a new Fedora workstation with essential applications and configurations.

## Installation

First, install Ansible:

```bash
sudo dnf install ansible
```

## Running the Playbook

To set up your Fedora system:

```bash
cd ~/dotfiles/ansible
ansible-playbook setup-fedora.yml
```

## What Gets Installed

- **1Password** - Password manager
- **Google Chrome** - Web browser (replaces Firefox)
- **Visual Studio Code** - Code editor
- **vim** - Terminal text editor

## What Gets Configured

- Removes Firefox (replaced by Chrome)
- Updates all system packages
- Adds necessary repositories and GPG keys
- Clones dotfiles repository to user home directory

## Manual Steps After Running

1. Run the dotfiles installation:

   ```bash
   cd ~/dotfiles
   ./install.sh
   ```

2. Configure 1Password and sign in
3. Set up Visual Studio Code extensions and settings
