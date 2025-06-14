---
applyTo: "**/*.ansible.yml"
---

# Ansible Instructions

When working with Ansible files in this dotfiles repository:

## General Guidelines

- Use YAML syntax with 2-space indentation
- Always include descriptive task names
- Use `become: yes` for tasks requiring sudo privileges
- Use `become_user: "{{ original_user }}"` when performing actions as the regular user

## Playbook Structure

- Target `hosts: localhost` with `connection: local` for local machine setup
- Use variables for user paths and common values
- Group related tasks logically with comments

## Package Management

- Use `dnf` module for Fedora package installation
- Add external repositories before installing packages from them
- Import GPG keys before adding repositories
- Always specify `state: present` or `state: latest` explicitly
- **Desktop applications via Flatpak**: Use Flatpak for desktop apps UNLESS they need system integration
- **System integration exceptions**: Chrome, 1Password, and VS Code should use native packages for better system integration
- Use FQCN (Fully Qualified Collection Names) for all modules (e.g., `ansible.builtin.dnf`)
- Group packages logically by purpose (desktop apps, dev tools, CLI utilities, etc.)
- Add comments explaining what each package does

## Best Practices

- Remove unwanted default packages (like Firefox) if installing alternatives
- Clone dotfiles repository to user home directory as the regular user
- Use `force: yes` for git operations to handle existing directories
- Include package updates in the playbook
- Use `true`/`false` instead of `yes`/`no` for boolean values
- Make tasks idempotent where possible
- Use `update: false` for git operations to prevent unnecessary updates
- Enable and start services like Docker after installation
- Add users to appropriate groups (e.g., docker group for Docker usage)
- Configure GNOME settings via dconf when needed

## Security

- Always verify GPG keys for external repositories
- Use HTTPS URLs for repositories when available
- Enable `gpgcheck` and `repo_gpgcheck` for all repositories

## User Context

- Use `{{ ansible_env.SUDO_USER }}` for the original user who ran sudo
- Use `{{ ansible_env.USER }}` for the current user context
- Use `{{ ansible_env.HOME }}` for home directory paths

## File Naming

- Use descriptive names that include `ansible` in the filename (e.g., `fedora-workstation.ansible.yml`)
- This ensures GitHub Copilot auto-attaches the ansible.instructions.md file
- Place all Ansible files in the `ansible/` directory

## Linting and Quality

- **MUST respect ALL ansible linting rules** - no exceptions
- Always run `ansible-lint` to ensure best practices
- Fix ALL linting errors before committing - zero tolerance for linting violations
- Use `ansible-playbook --syntax-check` to verify syntax
- Run linting after every change to catch issues early
