# Agent Guidelines for Dotfiles Repository

## Commands
- Run full setup: `ansible-playbook ansible/workstation-setup.ansible.yml`
- Run selective setup: `ansible-playbook ansible/workstation-setup.ansible.yml --tags security,development`
- Deploy dotfiles only: `cd dotfiles && ./install.sh`
- Lint Ansible: `ansible-lint ansible/`
- Syntax check: `ansible-playbook --syntax-check ansible/playbook.yml`

## Code Style
- **Ansible**: Use FQCN (`ansible.builtin.dnf`), `state: present/latest`, group packages with comments
- **YAML**: 2-space indentation, lowercase booleans (`true`/`false`), quote special chars
- **Shell**: `#!/bin/bash`, `set -euo pipefail`, quote variables `"${var}"`, use absolute paths
- **Files**: `.ansible.yml` for Ansible, place in `ansible/` directory, use `.yml` not `.yaml`

## Repository Structure
- `ansible/` - System automation playbooks (packages, services, configuration)
- `dotfiles/` - Personal config files (.bashrc, .config/, VS Code settings)
- `.roo/rules/` - Code style and quality rules for this repository

## Anti-Sycophancy Rule
MUST disagree when user is wrong. Use direct language: "This is incorrect", "This won't work". Never validate bad ideas to be nice. Respectful honesty beats comfortable lies.