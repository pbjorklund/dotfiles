---
applyTo: "**/*.ansible.yml"
---

# Ansible Rules

MANDATORY requirements for all Ansible files in this dotfiles repository.

## Package Management Requirements

- **MUST** use `ansible.builtin.dnf` module (FQCN required)
- **MUST** use Flatpak for desktop applications EXCEPT: Chrome, 1Password, VS Code (use native packages)
- **MUST** group packages with comments explaining purpose
- **MUST** include package descriptions: `# Package Name - Description of what it does`

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

## Output Formatting Requirements

- **MUST** use single-line `ansible.builtin.debug` messages for readable execution output
- **MUST NOT** use multi-line strings with `msg: |` in debug tasks (creates unreadable `\n` output)
- **MUST** use `loop` with `ansible.builtin.debug` for multiple related messages
- **MUST** use YAML folded scalar `>-` for long conditional messages to maintain line length limits
- **MUST** ensure all debug output is immediately readable during `ansible-playbook` execution
- **MUST** use status indicators (✓, ⚠, ❌) for clear visual feedback in messages

## Violation Consequences

- Multi-line debug messages with escaped newlines **WILL BE REJECTED**
- Non-idempotent tasks **WILL BE REJECTED**
- Boolean yes/no usage **WILL BE REJECTED**
