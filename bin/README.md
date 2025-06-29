# Local Scripts

This directory contains custom scripts that are symlinked to `~/.local/bin` via the dotfiles install script.

## pbproject

A project initialization and management tool that creates new projects with symlinked base configuration files from this dotfiles repository.

### Features

- **Quick project setup**: Initialize new projects with consistent base configuration
- **Symlinked templates**: Start with shared configuration that updates automatically
- **Detach mechanism**: Convert symlinks to copies when project-specific customization is needed
- **Status checking**: See which files are symlinked vs independent copies

### Usage

```bash
# Create new project with base configuration
pbproject init my-new-project

# Create project at specific location  
pbproject init my-app ~/projects/my-app

# Check current project status
pbproject status

# Detach symlinks to create independent copies
pbproject detach

# Migrate folder from existing project to new standalone project
pbproject migrate batch_writer ~/Projects/cli-tool

# Migrate current directory to new project  
pbproject migrate .

# Create private GitHub repository for current project
pbproject newghrepo
```

### Base Files

Projects are initialized with symlinks to these files from the dotfiles repository:

- **AGENTS.md**: AI agent instructions and context
- **.roo/**: Roo configuration directory  
- **.github/**: GitHub workflows, templates, and repository configuration

### Workflow

1. **Start new project**: Use `pbproject init project-name` to create a project with symlinked base files
2. **Develop**: Write code while benefiting from shared, up-to-date base configuration
3. **Migrate folders**: Use `pbproject migrate folder-name` to extract growing components from monorepos
4. **GitHub integration**: Use `pbproject newghrepo` to create private repositories and push code
5. **Customize when needed**: Run `pbproject detach` to replace symlinks with copies you can modify
6. **Independent development**: Continue building with project-specific configuration

This approach allows you to:
- Rapidly prototype with consistent tooling
- Keep small projects lightweight with shared configuration
- Extract growing components from monorepos into standalone projects
- Automatically create GitHub repositories for new projects
- Easily upgrade base configuration across all linked projects
- Transition to custom configuration only when necessary

### Installation

The script is automatically symlinked to `~/.local/bin/pbproject` when you run `dotfiles/install.sh`.
