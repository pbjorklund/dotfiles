---
applyTo: "**/*.ansible.yml"
---

# Ansible Rules

MANDATORY requirements for all Ansible files in this dotfiles repository.

## Package Management Requirements

- **MUST** use `ansible.builtin.dnf` module (FQCN required)
- **MUST** use Flatpak for desktop applications EXCEPT: Chrome, 1Password, VS Code (use native packages)
- **MUST** include package descriptions: `# Package Name - Description of what it does`
- **MUST** allow flatpack override for session bus for obsidian md
- **MUST** allow flatpack override for for wayland socket for plexamp

## User Context Requirements

- **MUST** use `{{ ansible_env.SUDO_USER }}` for original user who ran sudo
- **MUST** use `{{ ansible_env.USER }}` for current execution context
- **MUST** use `{{ ansible_env.HOME }}` for home directory paths
- **MUST** clone dotfiles to user home as regular user (not root)

## File Naming Requirements

- **MUST** include `ansible` in filename (e.g., `fedora-workstation.ansible.yml`)
- **MUST** place all Ansible files in `ansible/` directory
- **MUST** use `.yml` extension (not `.yaml`)

## Execution Requirements

- **MUST** run playbooks with `ansible-playbook` (not `--ask-become-pass` or `sudo`)
- **MUST NOT** run playbooks with `sudo`

## Quality Assurance Requirements

- **MUST** be idempotent (safe to run multiple times)

## Violation Consequences

- Multi-line debug messages with escaped newlines **WILL BE REJECTED**
- Non-idempotent tasks **WILL BE REJECTED**
