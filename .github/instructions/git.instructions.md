---
applyTo: "**/{.gitconfig,.gitignore,.git*}"
---

# Git Instructions

When working with this dotfiles repository:

## Commit Guidelines

- Use conventional commit format: `type(scope): description`
- Common types: feat, fix, docs, style, refactor, chore
- Keep commit messages under 50 characters for the subject line
- Use present tense ("Add feature" not "Added feature")

## Branch Strategy

- Work on feature branches for significant changes
- Use descriptive branch names (e.g., `feature/ansible-gnome-setup`)
- Keep main/master branch stable and deployable
- Merge or rebase feature branches cleanly

## File Management

- Don't commit sensitive information (passwords, tokens, personal data)
- Use .gitignore for system-generated files
- Keep repository clean and organized
- Remove obsolete files rather than leaving them unused

## Configuration Changes

- Test configuration changes before committing
- Document breaking changes in commit messages
- Consider backward compatibility
- Update documentation when config changes

## Best Practices

- Make atomic commits (one logical change per commit)
- Review changes before committing
- Use meaningful commit messages
- Keep commit history clean and readable

## Security

- Never commit secrets or personal information
- Use environment variables or config files for sensitive data
- Review diffs before pushing to ensure no secrets are included
- Consider using git-secrets or similar tools
