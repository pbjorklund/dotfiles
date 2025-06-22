#!/bin/bash
set -euo pipefail
############################
# install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# Features: Dotfiles symlinks, .config directory management, system config files, backup creation
#
# RESPONSIBILITY: Personal configuration file deployment (NOT system packages)
# - Dotfiles symlinking (.bashrc, .gitconfig, .tmux.conf, etc.)
# - .config directory management (hypr, waybar, kitty, etc.)
# - VS Code settings deployment
# - System integration files (systemd sleep hooks)
#
# System packages and services are handled by Ansible playbooks
############################

########## Variables

dir=~/dotfiles/dotfiles                                  # dotfiles directory
repo_root=~/dotfiles                                     # repository root directory
backup_dir="/tmp/dotfiles-backup-$(date +%Y%m%d-%H%M%S)" # temporary backup with timestamp
# List of files to symlink in homedir (excluding directories and install script)
files="bashrc gitconfig tmux.conf inputrc"
# List of .config subdirectories to symlink
config_dirs="hypr swaylock waybar zellij mako wofi systemd kitty gh"
# System files that need to be copied (not symlinked) to system locations
system_files_to_copy=".config/hypr/scripts/systemd-sleep-hook.sh:/lib/systemd/system-sleep/hyprland-lid-state"
# VS Code settings file (user settings location)
vscode_settings_file=".config/Code/User/settings.json"

##########

# create backup directory in /tmp
echo "Creating $backup_dir for backup of any existing dotfiles"
mkdir -p "$backup_dir"
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to backup directory, then create symlinks
for file in $files; do
    if [ -f ~/".$file" ]; then
        echo "Moving existing .$file to $backup_dir"
        mv ~/."$file" "$backup_dir/"
    fi
    echo "Creating symlink to $file in home directory."
    ln -sf "$dir/$file" ~/."$file"
done

# Handle .config directory management
echo "Setting up .config directory symlinks"
mkdir -p ~/.config

# Create symlinks for .config subdirectories
for config_dir in $config_dirs; do
    if [ -e ~/.config/"$config_dir" ]; then
        echo "Moving existing .config/$config_dir to $backup_dir"
        mv ~/.config/"$config_dir" "$backup_dir/"
    fi
    echo "Creating symlink to .config/$config_dir"
    ln -sf "$dir/.config/$config_dir" ~/.config/"$config_dir"
done

# Handle VS Code settings
echo "Setting up VS Code settings"
mkdir -p ~/.config/Code/User
if [ -f ~/.config/Code/User/settings.json ]; then
    echo "Moving existing VS Code settings.json to $backup_dir"
    mv ~/.config/Code/User/settings.json "$backup_dir/"
fi
echo "Creating symlink to VS Code settings.json"
ln -sf "$dir/$vscode_settings_file" ~/.config/Code/User/settings.json

# Handle system configuration files (requires sudo)
echo "Setting up system configuration files"

# Install system files (systemd sleep hooks, etc.)
for system_file_mapping in $system_files_to_copy; do
    source_file="${system_file_mapping%:*}"
    dest_file="${system_file_mapping#*:}"

    if [[ -f "$dir/$source_file" ]]; then
        echo "Installing system file: $source_file -> $dest_file"
        if [[ -f "$dest_file" ]]; then
            echo "Moving existing $dest_file to $backup_dir"
            sudo cp "$dest_file" "$backup_dir/"
        fi
        sudo cp "$dir/$source_file" "$dest_file"
        sudo chmod +x "$dest_file"
    else
        echo "⚠ Warning: System file $source_file not found"
    fi
done

echo ""
echo "Dotfiles installation complete!"
echo "Backup files saved to: $backup_dir"
echo ""

# Post-installation setup for systemd user services
echo "Setting up systemd user services..."
if systemctl --user daemon-reload; then
    echo "Reloaded systemd user daemon"

    # Enable and start the resume monitor service if it exists
    if [[ -f ~/.config/systemd/user/hyprland-resume-monitor.service ]]; then
        if systemctl --user enable hyprland-resume-monitor.service; then
            echo "Enabled hyprland-resume-monitor.service"
            if systemctl --user start hyprland-resume-monitor.service; then
                echo "Started hyprland-resume-monitor.service"
            else
                echo "⚠ Warning: Failed to start hyprland-resume-monitor.service"
            fi
        else
            echo "⚠ Warning: Failed to enable hyprland-resume-monitor.service"
        fi
    fi

    # Enable and start the waybar watcher service if it exists
    if [[ -f ~/.config/systemd/user/waybar-watcher.service ]]; then
        if systemctl --user enable waybar-watcher.service; then
            echo "Enabled waybar-watcher.service"
            if systemctl --user start waybar-watcher.service; then
                echo "Started waybar-watcher.service"
            else
                echo "⚠ Warning: Failed to start waybar-watcher.service"
            fi
        else
            echo "⚠ Warning: Failed to enable waybar-watcher.service"
        fi
    fi
else
    echo "⚠ Warning: Failed to reload systemd user daemon"
fi

echo ""
echo "🎉 Setup complete! Hyprland lid switch functionality has been configured."
echo "📝 The laptop display will now stay disabled when lid is closed and external monitors are connected."
echo ""
