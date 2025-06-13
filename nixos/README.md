# NixOS Configuration

This directory contains my NixOS system configuration.

## Workflow

1. **Edit configuration**: Open VS Code in this directory
   ```bash
   nixedit  # alias for: code ~/dotfiles/nixos
   ```

2. **Test configuration**: Test changes without committing
   ```bash
   nixtest  # alias for: sudo nixos-rebuild test --show-trace
   ```

3. **Deploy configuration**: Copy to `/etc/nixos` and activate
   ```bash
   nixdeploy  # runs: ~/dotfiles/nixos/deploy.sh
   ```

## Available Aliases

- `nixedit` - Open configuration in VS Code
- `nixdeploy` - Deploy configuration using the script
- `nixtest` - Test configuration without switching
- `nixswitch` - Switch to new configuration
- `nixboot` - Set configuration for next boot
- `nixgc` - Garbage collect old generations
- `nixupdate` - Update and switch to latest packages

## Files

- `configuration.nix` - Main system configuration
- `hardware-configuration.nix` - Hardware-specific configuration (auto-generated)
- `deploy.sh` - Deployment script

## Git Workflow

```bash
# Make changes to configuration.nix
nixedit

# Test the changes
nixtest

# If everything works, deploy
nixdeploy

# Commit to git
git add -A
git commit -m "Update NixOS configuration"
git push
```

This setup allows you to:
- Edit configuration files as a regular user in VS Code
- Test changes before deploying
- Keep configuration under version control
- Only need sudo when actually deploying changes
