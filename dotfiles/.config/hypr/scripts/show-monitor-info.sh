#!/bin/bash
# Monitor Information Helper - Shows stable monitor identifiers
# Run this script to see the stable monitor descriptions that should be used
# in Hyprland configuration instead of connector names like DVI-I-1, DVI-I-2

echo "=== Current Monitor Configuration ==="
echo "This shows the stable monitor identifiers you should use in Hyprland config:"
echo

if ! command -v hyprctl >/dev/null 2>&1; then
    echo "Error: hyprctl not found. This script must be run in a Hyprland session."
    exit 1
fi

if ! hyprctl monitors -j >/dev/null 2>&1; then
    echo "Error: Cannot query monitors. Make sure Hyprland is running."
    exit 1
fi

# Show all monitors with their stable identifiers
hyprctl monitors -j | jq -r '.[] |
    "Monitor: \(.name)
    Description: \(.description)
    Resolution: \(.width)x\(.height)@\(.refreshRate)
    Position: \(.x),\(.y)
    Scale: \(.scale)
    ---"'

echo
echo "=== Configuration Recommendations ==="
echo "Use these in your hyprland.conf monitor section:"
echo

hyprctl monitors -j | jq -r '.[] |
    "# \(.description)
    monitor = desc:\(.description), \(.width)x\(.height)@\(.refreshRate), \(.x)x\(.y), \(.scale)
    "'

echo
echo "=== For Scripts and Wallpapers ==="
echo "Use these stable identifiers in scripts instead of connector names:"
echo

hyprctl monitors -j | jq -r '.[] |
    "Monitor \(.name) -> \"desc:\(.description)\""'
