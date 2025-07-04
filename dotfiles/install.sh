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
config_dirs="hypr waybar zellij mako wofi systemd kitty gh nvim opencode niri"
# List of system config directories that need to be copied (not symlinked) to system locations
system_config_dirs=""
# List of dotfiles directories to symlink (containing multiple files)
dotfile_dirs=""
# System files that need to be copied (not symlinked) to system locations
system_files_to_copy=".config/hypr/scripts/disable-usb-wakeup.sh:/usr/local/bin/disable-usb-wakeup.sh"
# System service files that need to be installed
system_services=".config/systemd/system/disable-usb-wakeup.service:/etc/systemd/system/disable-usb-wakeup.service"
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

# Create symlinks for dotfiles directories
for dotfile_dir in $dotfile_dirs; do
    if [ -e ~/."$dotfile_dir" ]; then
        echo "Moving existing .$dotfile_dir to $backup_dir"
        mv ~/."$dotfile_dir" "$backup_dir/"
    fi
    echo "Creating symlink to .$dotfile_dir"
    ln -sf "$dir/.$dotfile_dir" ~/."$dotfile_dir"
done

# Handle local bin directory for custom scripts
echo "Setting up local bin directory"
mkdir -p ~/.local/bin
if [ -e ~/.local/bin/pbproject ]; then
    echo "Moving existing pbproject to $backup_dir"
    mv ~/.local/bin/pbproject "$backup_dir/"
fi
echo "Creating symlink to pbproject script"
ln -sf "$repo_root/bin/pbproject" ~/.local/bin/pbproject

# Handle VS Code settings
echo "Setting up VS Code settings"
mkdir -p ~/.config/Code/User
if [ -f ~/.config/Code/User/settings.json ]; then
    echo "Moving existing VS Code settings.json to $backup_dir"
    mv ~/.config/Code/User/settings.json "$backup_dir/"
fi
echo "Creating symlink to VS Code settings.json"
ln -sf "$dir/$vscode_settings_file" ~/.config/Code/User/settings.json

# Handle Claude settings
echo "Setting up Claude settings"
mkdir -p ~/.claude
if [ -f ~/.claude/settings.json ]; then
    echo "Moving existing Claude settings.json to $backup_dir"
    mv ~/.claude/settings.json "$backup_dir/"
fi
echo "Creating symlink to Claude settings.json"
ln -sf "$dir/.claude/settings.json" ~/.claude/settings.json

# Handle system configuration files (requires sudo)
echo "Setting up system configuration files"

# Install system config directories
for system_config_dir in $system_config_dirs; do
    if [[ -d "$dir/.config/$system_config_dir" ]]; then
        echo "Installing system config directory: .config/$system_config_dir -> /etc/$system_config_dir"
        if [[ -d "/etc/$system_config_dir" ]]; then
            echo "Moving existing /etc/$system_config_dir to $backup_dir"
            sudo cp -r "/etc/$system_config_dir" "$backup_dir/"
        fi
        sudo cp -r "$dir/.config/$system_config_dir" "/etc/"
    else
        echo "⚠ Warning: System config directory .config/$system_config_dir not found"
    fi
done

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

# Install system service files
for service_mapping in $system_services; do
    source_service="${service_mapping%:*}"
    dest_service="${service_mapping#*:}"

    if [[ -f "$dir/$source_service" ]]; then
        echo "Installing system service: $source_service -> $dest_service"
        if [[ -f "$dest_service" ]]; then
            echo "Moving existing $dest_service to $backup_dir"
            sudo cp "$dest_service" "$backup_dir/"
        fi
        sudo cp "$dir/$source_service" "$dest_service"

        # Extract service name from destination path
        service_name=$(basename "$dest_service")
        echo "Enabling and starting system service: $service_name"

        if sudo systemctl daemon-reload; then
            if sudo systemctl enable "$service_name"; then
                echo "Enabled $service_name"
                if sudo systemctl start "$service_name"; then
                    echo "Started $service_name"
                else
                    echo "⚠ Warning: Failed to start $service_name"
                fi
            else
                echo "⚠ Warning: Failed to enable $service_name"
            fi
        else
            echo "⚠ Warning: Failed to reload systemd daemon"
        fi
    else
        echo "⚠ Warning: System service file $source_service not found"
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

    # Enable waybar and waybar-watcher services if they exist
    for service in waybar.service waybar-watcher.service; do
        if [[ -f ~/.config/systemd/user/$service ]]; then
            if systemctl --user enable "$service"; then
                echo "Enabled $service"
                if systemctl --user start "$service"; then
                    echo "Started $service"
                else
                    echo "⚠ Warning: Failed to start $service"
                fi
            else
                echo "⚠ Warning: Failed to enable $service"
            fi
        fi
    done
else
    echo "⚠ Warning: Failed to reload systemd user daemon"
fi

echo ""
echo "🎉 Setup complete!📝"
echo ""
