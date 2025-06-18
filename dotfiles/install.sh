#!/bin/bash
set -euo pipefail
############################
# install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# Features: Dotfiles symlinks, .config directory management, system config files, backup creation
############################

########## Variables

dir=~/dotfiles/dotfiles                                  # dotfiles directory
repo_root=~/dotfiles                                     # repository root directory
backup_dir="/tmp/dotfiles-backup-$(date +%Y%m%d-%H%M%S)" # temporary backup with timestamp
# List of files to symlink in homedir (excluding directories and install script)
files="bashrc gitconfig tmux.conf inputrc"
# List of .config subdirectories to symlink
config_dirs="hypr swaylock waybar zellij mako wofi systemd kitty"
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

# Timeshift configuration
if [[ -f "$repo_root/timeshift.json" ]]; then
    echo "Setting up Timeshift configuration"
    sudo mkdir -p /etc/timeshift
    if [[ -f /etc/timeshift/timeshift.json ]]; then
        echo "Moving existing Timeshift config to $backup_dir"
        sudo cp /etc/timeshift/timeshift.json "$backup_dir/"
    fi
    echo "Installing Timeshift configuration"
    sudo cp "$repo_root/timeshift.json" /etc/timeshift/timeshift.json
    sudo chmod 644 /etc/timeshift/timeshift.json
else
    echo "⚠ Warning: timeshift.json not found in repository root"
fi

echo ""
echo "Dotfiles installation complete!"
echo "Backup files saved to: $backup_dir"
echo ""
