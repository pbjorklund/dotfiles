#!/bin/bash

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
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
