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

## Best Practices
- Remove unwanted default packages (like Firefox) if installing alternatives
- Clone dotfiles repository to user home directory as the regular user
- Use `force: yes` for git operations to handle existing directories
- Include package updates in the playbook

## Security
- Always verify GPG keys for external repositories
- Use HTTPS URLs for repositories when available
- Enable `gpgcheck` and `repo_gpgcheck` for all repositories

## User Context
- Use `{{ ansible_env.SUDO_USER }}` for the original user who ran sudo
- Use `{{ ansible_env.USER }}` for the current user context
- Use `{{ ansible_env.HOME }}` for home directory paths
