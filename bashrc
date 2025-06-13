#!/bin/bash
# Minimal safe bashrc for recovery

# NixOS Configuration Management Aliases
alias nixedit="code ~/dotfiles/nixos"
alias nixdeploy="bash ~/dotfiles/nixos/deploy.sh"
alias nixtest="sudo nixos-rebuild test --show-trace"
alias nixswitch="sudo nixos-rebuild switch --show-trace"
alias nixboot="sudo nixos-rebuild boot --show-trace"
alias nixgc="sudo nix-collect-garbage -d"
alias nixupdate="sudo nixos-rebuild switch --upgrade --show-trace"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Basic settings
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# Simple prompt
PS1='\u@\h:\w\$ '

# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ls='ls --color=auto'

echo "Safe bashrc loaded successfully"
