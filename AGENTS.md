# AGENTS.md - Dotfiles Repository Guide

## Core Principles
- **Modular by design**: Each ansible playbook targets specific functionality for selective execution
- **Security first**: Public configs contain no real credentials - protects against accidental exposure
- **Idempotent automation**: Safe to run repeatedly without breaking existing setups
- **Lint-enforced quality**: All code must pass automated validation for reliability

## File Organization (WHY this structure)
- `ansible/*.ansible.yml` - Clear namespace prevents confusion with other YAML files
- `bin/*.sh` - Executable utilities separate from config files for PATH management
- `dotfiles/` by application - Logical grouping enables partial installations
- `dotfiles/install.sh` installs and symlinks all dotfiles in correct paths on client
- `project-templates/` - Reusable patterns reduce setup time for new projects

## Code Standards (Preventing common failures)
- **Ansible FQCN required** - `ansible.builtin.dnf` prevents module resolution issues
- **Shell strict mode** - `set -euo pipefail` catches errors early and prevents silent failures
- **Variable quoting** - `"${var}"` prevents word splitting and path issues
- **Placeholder data only** - Prevents accidental credential commits in public repos

## Development Rules
- Run validation workflow before every commit (prevents broken deployments)
- Use absolute paths (avoids dependency on working directory)
- Test file existence before operations (prevents cryptic error messages)
- Modular, tagged playbooks enable users to install only what they need
