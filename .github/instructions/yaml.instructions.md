---
applyTo: "**/*.{yml,yaml}"
---

# YAML Rules

MANDATORY requirements for all YAML files in this dotfiles repository.

## Syntax Requirements

- **MUST** use exactly 2 spaces for indentation (no tabs)
- **MUST** use spaces only (tabs are forbidden)
- **MUST** quote strings containing special characters: `:`, `{`, `}`, `[`, `]`, `,`, `&`, `*`, `#`, `?`, `|`, `-`, `<`, `>`, `=`, `!`, `%`, `@`, `` ` ``
- **MUST** use lowercase boolean values: `true`/`false` (not `True`/`False` or `YES`/`NO`)
- **MUST** end files with newline character

## Structure Requirements

- **MUST** group related settings into clearly labeled sections
- **MUST** use descriptive key names in snake_case or kebab-case consistently
- **MUST** limit nesting to maximum 4 levels deep
- **MUST** add comments for all non-obvious configurations using `# Comment`
- **MUST** separate logical sections with blank lines

## Data Type Requirements

- **MUST** quote strings that could be interpreted as numbers, booleans, or null: `"123"`, `"true"`, `"null"`
- **MUST** use explicit null value: `null` (not `~` or empty)
- **MUST** use ISO 8601 format for dates: `2023-12-31T23:59:59Z`
- **MUST** quote version numbers: `"1.0.0"` (not `1.0.0`)

## Comment Requirements

- **MUST** include file header comment explaining purpose
- **MUST** document all configuration sections with comments
- **MUST** explain any non-standard or complex values
- **MUST** include examples in comments for complex structures

## Validation Requirements

- **MUST** validate YAML syntax before committing using `yamllint` or equivalent
- **MUST** pass YAML linting with zero violations
- **MUST** test configurations after changes to ensure functionality
- **MUST** verify all referenced files and paths exist

## Organization Requirements

- **MUST** keep files focused on single configuration purpose
- **MUST** use YAML anchors (`&anchor`) and aliases (`*anchor`) for repeated structures
- **MUST** place anchors at document top before first usage
- **MUST** maintain consistent formatting across all YAML files

## Security Requirements

- **SHALL NOT** include passwords, tokens, API keys, or sensitive data
- **MUST** use environment variable references: `${ENV_VAR}` or `!env ENV_VAR`
- **MUST** quote all user-provided strings to prevent injection
- **MUST** validate all external references

## Performance Requirements

- **MUST** avoid deeply nested structures (>4 levels) for parsing efficiency
- **MUST** use arrays instead of numbered keys: `items: [a, b, c]` not `item1: a, item2: b`
- **MUST** minimize file size by avoiding redundant structures

## Violation Consequences

- Files failing YAML syntax validation **WILL BE REJECTED**
- Files with tab indentation **WILL BE REJECTED**
- Files containing sensitive data **WILL BE REJECTED**
- Files without proper comments **WILL BE REJECTED**

## Applies To

- `**/*.{yml,yaml}`
- YAML configuration files
- Files like `ansible.cfg` and other YAML configs
