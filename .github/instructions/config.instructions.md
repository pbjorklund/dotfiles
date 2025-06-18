---
applyTo: "**/{.*rc,.*conf,.*config}"
---

# Configuration Files Rules

MANDATORY requirements for all dotfiles and configuration files in this repository.

## File Structure Requirements

- **MUST** include comment header with file purpose and key features
- **MUST** organize settings into clearly labeled sections using `# Section Name`
- **MUST** place most critical settings at the top of each section
- **MUST** separate sections with blank lines for readability

## Cross-Platform Requirements

- **MUST** use OS detection: `case "$(uname -s)" in Darwin|Linux|CYGWIN*)`
- **MUST** check command existence: `command -v cmd >/dev/null 2>&1 && cmd`
- **MUST** provide fallback values for missing tools
- **MUST** document OS-specific sections with comments

## Security Requirements

- **SHALL NOT** include tokens, passwords, API keys, or secrets
- **MUST** use `chmod 600` for sensitive config files
- **MUST** use environment variables: `${HOME}`, `${USER}` instead of hardcoded paths
- **MAY** include personal usernames, emails, and device names in configuration files
- **MUST** ensure personal data inclusion is intentional for repository maintainer

## Comment Requirements

- **MUST** explain non-obvious settings with inline comments
- **MUST** include purpose comments for custom functions or aliases
- **MUST** document keybindings and shortcuts
- **MUST** include URL references for complex configurations

## Validation Requirements

- **MUST** validate syntax before committing (shell: `bash -n file`, tmux: `tmux source file`)
- **MUST** test configurations on clean system before deploying
- **MUST** verify all referenced files and commands exist
- **MUST** ensure configurations are compatible with target systems

## Violation Consequences

- Files with syntax errors **WILL BE REJECTED**
- Files containing real personal data **WILL BE REJECTED**
- Files without proper comments **WILL BE REJECTED**
- Files failing validation **WILL BE REJECTED**

## Applies To

- `**/{.*rc,.*conf,.*config}`
- Configuration files like `bashrc`, `gitconfig`, `tmux.conf`
- Hidden configuration files and directories
