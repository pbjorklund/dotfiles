#!/bin/bash
# External script to trigger bell on specific tmux window
# Usage: trigger-bell-external.sh <session:window>

target_window="$1"
if [ -z "$target_window" ]; then
    echo "Usage: $0 <session:window>"
    exit 1
fi

# Send bell to the specified window
tmux send-keys -t "$target_window" 'printf "\\a"' Enter