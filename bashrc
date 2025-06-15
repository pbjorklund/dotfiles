#!/bin/bash

# Bash configuration for development workstation
# Features: extended history, useful aliases, modern editor integration

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# History Configuration
shopt -s histappend                    # Append to history file, don't overwrite
HISTSIZE=10000                         # Commands in memory
HISTFILESIZE=20000                     # Commands in history file
shopt -s checkwinsize                  # Update window size after each command

# Editor Configuration
export EDITOR=nvim                     # Use neovim as default editor

# Prompt Configuration
PS1='\u@\h:\w\$ '                     # Simple user@host:path$ prompt

# Essential Aliases
alias ll='ls -alF'                     # Long listing with file types
alias la='ls -A'                       # All files except . and ..
alias l='ls -CF'                       # Compact listing with file types
alias grep='grep --color=auto'         # Colorized grep output
alias ls='ls --color=auto'             # Colorized ls output

# Conditional Loading
# Load additional configurations if they exist
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_local ]] && source ~/.bash_local
