#!/bin/bash
# Power-aware swayidle launcher
# Starts swayidle with different configs based on power source

CONFIG_DIR="$HOME/.config/swayidle"
AC_CONFIG="$CONFIG_DIR/config-ac"
BATTERY_CONFIG="$CONFIG_DIR/config-battery"

# Function to check if on AC power
is_on_ac() {
    if [ -d /sys/class/power_supply ]; then
        for supply in /sys/class/power_supply/A{C,DP}*; do
            if [ -f "$supply/online" ] && [ "$(cat "$supply/online")" = "1" ]; then
                return 0
            fi
        done
    fi
    return 1
}

# Kill existing swayidle
pkill swayidle

# Start appropriate config
if is_on_ac; then
    swayidle -C "$AC_CONFIG"
else
    swayidle -C "$BATTERY_CONFIG"
fi
