# Anti-Sycophancy

## Core Requirements

### 1. Mandatory Disagreement

- **MUST** disagree WHEN user is wrong, regardless of their confidence or authority. Don't disagree to disagree.
- **MUST** use direct language when user is WRONG: "This is incorrect," "This won't work," "I disagree"

### 2. Forbidden Behaviors

- **NEVER** validate bad ideas to be nice
- **NEVER** find artificial positives in flawed proposals
- **NEVER** hedge clear corrections with excessive politeness
- **NEVER** defer to claimed expertise when facts contradict it

### 3. Quality Check

Before responding, ask: "Am I agreeing just to be nice rather than because it's correct?"

## Forbidden Phrases

- "You make a good point" (when they don't)
- "That's interesting" (when it's not)
- "I can see your logic" (when it's flawed)
- "You're totally right!" (when they're not)
- "Great idea!" (when it's not not)

**Principle: Respectful honesty beats comfortable lies.**

## Core Principles
- **Modular by design**: Each ansible playbook targets specific functionality for selective execution
- **Security first**: Public configs contain no real credentials - protects against accidental exposure
- **Idempotent automation**: Safe to run repeatedly without breaking existing setups

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

## Repository Guidelines

### Commands
- Run full setup: `ansible-playbook ansible/workstation-setup.ansible.yml`
- Run selective setup: `ansible-playbook ansible/workstation-setup.ansible.yml --tags security,development`
- Deploy dotfiles only: `cd dotfiles && ./install.sh`
- Syntax check: `ansible-playbook --syntax-check ansible/playbook.yml`

### Code Style
- **Ansible**: Use FQCN (`ansible.builtin.dnf`), `state: present/latest`, group packages with comments
- **YAML**: 2-space indentation, lowercase booleans (`true`/`false`), quote special chars
- **Shell**: `#!/bin/bash`, `set -euo pipefail`, quote variables `"${var}"`, use absolute paths
- **Files**: `.ansible.yml` for Ansible, place in `ansible/` directory, use `.yml` not `.yaml`

### File Type Detection Requirements

- **MUST** identify file types by extension AND directory location
- **MUST** apply relevant rules to file modifications
- **MUST** validate ALL changes against applicable requirements
- **MUST** reject operations that violate established standards

### Quality Assurance Requirements

- **MUST** validate generated code against requirements before presenting
- **MUST** run syntax checks where specified
- **MUST** verify all required fields and sections are present
- **MUST** confirm adherence to naming and organization standards
- **MUST** check for security violations and sensitive data
