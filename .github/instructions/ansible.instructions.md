---
applyTo: "**/*.ansible.yml"
---

# Ansible Rules

MANDATORY requirements for all Ansible files in this dotfiles repository.

## Package Management Requirements

- **MUST** use `ansible.builtin.dnf` module (FQCN required)
- **MUST** add repositories BEFORE installing packages from them
- **MUST** import GPG keys BEFORE adding repositories
- **MUST** explicitly specify `state: present` or `state: latest`
- **MUST** use Flatpak for desktop applications EXCEPT: Chrome, 1Password, VS Code (use native packages)
- **MUST** group packages with comments explaining purpose
- **MUST** include package descriptions: `# Package Name - Description of what it does`

## User Context Requirements

- **MUST** use `{{ ansible_env.SUDO_USER }}` for original user who ran sudo
- **MUST** use `{{ ansible_env.USER }}` for current execution context
- **MUST** use `{{ ansible_env.HOME }}` for home directory paths
- **MUST** clone dotfiles to user home as regular user (not root)

## Service Management Requirements

- **MUST** enable services using `enabled: true`
- **MUST** start services using `state: started`
- **MUST** add users to required groups (e.g., docker group for Docker)

## File Naming Requirements

- **MUST** include `ansible` in filename (e.g., `fedora-workstation.ansible.yml`)
- **MUST** place all Ansible files in `ansible/` directory
- **MUST** use `.yml` extension (not `.yaml`)

## Execution Requirements

- **MUST** run playbooks with `ansible-playbook` (not `--ask-become-pass` or `sudo`)
- **MUST** configure `become_ask_pass = False` in `ansible.cfg`
- **MUST** verify idempotency by running playbook multiple times

## Quality Assurance Requirements

- **MUST** pass `ansible-lint` with zero violations
- **MUST** pass `ansible-playbook --syntax-check`
- **MUST** be idempotent (safe to run multiple times)
- **MUST** include package updates in playbook using `state: latest`

## Violation Consequences

- Files failing ansible-lint **WILL BE REJECTED**
- Non-idempotent tasks **WILL BE REJECTED**
- Missing FQCN **WILL BE REJECTED**
- Boolean yes/no usage **WILL BE REJECTED**

## Applies To

- `**/*.ansible.yml`
- `**/*.yml` files in `ansible/` directory
- `ansible.cfg` configuration files
