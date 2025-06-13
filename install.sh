#!/bin/bash
############################
# install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
# List of files to symlink in homedir (excluding directories and install script)
files="bashrc gitconfig tmux.conf"

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    if [ -f ~/".$file" ]; then
        echo "Moving existing .$file from ~ to $olddir"
        mv ~/."$file" "$olddir/"
    fi
    echo "Creating symlink to $file in home directory."
    ln -sf "$dir/$file" ~/."$file"
done

echo ""
echo "Dotfiles installation complete!"
echo ""
echo "Available NixOS aliases:"
echo "  nixedit    - Open NixOS configuration in VS Code"
echo "  nixtest    - Test NixOS configuration"
echo "  nixdeploy  - Deploy NixOS configuration"
echo "  nixswitch  - Switch to new NixOS configuration"
echo "  nixboot    - Set NixOS configuration for next boot"
echo "  nixgc      - Garbage collect old generations"
echo "  nixupdate  - Update and switch to latest packages"
