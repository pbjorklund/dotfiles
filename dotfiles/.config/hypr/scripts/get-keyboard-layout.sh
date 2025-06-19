#!/bin/bash

# Get the current keyboard layout from the main keyboard
# This works with both laptop and USB keyboards

# Find the main keyboard
main_keyboard=$(hyprctl devices | grep -B 6 'main: yes' | grep -E '\s+(at-translated-set-2-keyboard|usb-keyboard)' | head -1 | sed 's/^\s*//' | sed 's/:$//')

if [ -n "$main_keyboard" ]; then
    # Get the layout of the main keyboard
    layout=$(hyprctl devices | grep -A 5 "$main_keyboard" | grep 'active keymap:' | head -1 | sed 's/.*active keymap: //')
    
    # Convert to short format
    case "$layout" in
        "English (US)") echo "EN" ;;
        "Swedish") echo "SE" ;;
        *) echo "$layout" ;;
    esac
else
    echo "??"
fi
