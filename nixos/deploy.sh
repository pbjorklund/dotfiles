#!/bin/bash

# NixOS Configuration Deployment Script
# This script copies your configuration from dotfiles to /etc/nixos and rebuilds

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIXOS_DIR="/etc/nixos"

echo "🔄 Deploying NixOS configuration..."

# Copy configuration files
echo "📁 Copying configuration files to $NIXOS_DIR"
sudo cp "$SCRIPT_DIR/configuration.nix" "$NIXOS_DIR/"
sudo cp "$SCRIPT_DIR/hardware-configuration.nix" "$NIXOS_DIR/"

# Set proper permissions
sudo chown root:root "$NIXOS_DIR"/*.nix
sudo chmod 644 "$NIXOS_DIR"/*.nix

# Test the configuration first
echo "🧪 Testing configuration..."
sudo nixos-rebuild test --show-trace

echo "✅ Configuration test successful!"

# Ask if user wants to switch
read -p "Do you want to switch to this configuration permanently? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Switching to new configuration..."
    sudo nixos-rebuild switch --show-trace
    echo "✅ Configuration deployed and activated!"
else
    echo "ℹ️  Configuration tested but not activated. Run 'sudo nixos-rebuild switch' to activate later."
fi
