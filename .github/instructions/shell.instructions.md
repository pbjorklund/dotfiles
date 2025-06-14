# Shell Script Instructions

When working with shell scripts in this dotfiles repository:

## General Guidelines
- Use bash as the default shell (`#!/bin/bash`)
- Include error handling with `set -e` for critical scripts
- Use descriptive variable names and comments
- Make scripts executable with proper permissions

## Installation Scripts
- Check for existing installations before installing
- Provide user feedback during installation steps
- Handle different Linux distributions when possible
- Create backup copies of existing configuration files

## Configuration Management
- Use symbolic links for dotfiles deployment
- Check if source files exist before creating links
- Provide options to force overwrite existing files
- Log actions taken for troubleshooting

## Error Handling
- Use `set -e` to exit on errors for critical operations
- Validate prerequisites before proceeding
- Provide meaningful error messages
- Include cleanup procedures for failed installations

## Best Practices
- Use absolute paths when possible
- Quote variables to handle spaces in paths
- Test scripts on clean systems
- Document script dependencies and requirements

## User Experience
- Show progress indicators for long operations
- Use colors for output when appropriate (with fallbacks)
- Provide --help options for complex scripts
- Allow dry-run mode for destructive operations
