#!/bin/bash

# Trigger tmux bell in current window
# This script sends a bell character to trigger tmux bell indicators

# Send bell character to terminal
echo -ne '\a'

# Also try sending it via tmux if we're in a tmux session
if [ -n "$TMUX" ]; then
    tmux send-keys -t $(tmux display -p '#S:#I.#P') 'C-g' 2>/dev/null || true
fi