#!/bin/bash
# Script to show global tmux activity/bell indicators

# Check for any window with activity flag
activity=$(tmux list-windows -F "#{window_activity_flag}" | grep -q 1 && echo "[A]" || echo "")

# Check for any window with bell flag  
bell=$(tmux list-windows -F "#{window_bell_flag}" | grep -q 1 && echo "[B]" || echo "")

# Output combined indicators
echo "${activity}${bell}"