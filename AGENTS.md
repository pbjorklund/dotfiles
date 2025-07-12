# AGENTS.md - Dotfiles Repository Guide

## Build/Test Commands
- Run Ansible playbook: `ansible-playbook ansible/workstation-setup.ansible.yml`
- Syntax check: `ansible-playbook --syntax-check ansible/<playbook>.ansible.yml`
- Lint Ansible: `ansible-lint ansible/<playbook>.ansible.yml`
- Shell syntax check: `bash -n <script>.sh`
- Install dotfiles: `cd dotfiles && ./install.sh`

## File Structure
- Ansible playbooks: `ansible/*.ansible.yml` (use `.yml` not `.yaml`)
- Shell scripts: `bin/*.sh` (must be executable)
- Config files: `dotfiles/` directory organized by application
- Templates: `project-templates/` for reusable configurations

## Code Style Guidelines
- **Ansible**: MUST use FQCN (`ansible.builtin.dnf`), `state: present/latest`, pass ansible-lint
- **Shell**: MUST use `#!/bin/bash`, `set -euo pipefail`, quote all variables `"${var}"`
- **Config files**: MUST include header comments, use sections, no real personal data
- **Security**: NO secrets, tokens, or real usernames in public configs

## Key Rules from .roo/rules/
- Be direct and honest - disagree when user is wrong, don't validate bad ideas
- Ansible files must be idempotent and lint-clean
- Use absolute paths, validate file existence before operations
- All shell scripts need error handling and meaningful messages

## File Naming
- Ansible: `name.ansible.yml` in `ansible/` directory
- Use placeholder values for personal data: "Your Name", "your.email@example.com"