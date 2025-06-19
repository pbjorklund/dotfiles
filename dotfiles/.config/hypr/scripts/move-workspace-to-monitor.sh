#!/bin/bash
# Move workspace to monitor by stable identifier - dynamically finds monitor ID
# Usage: move-workspace-to-monitor.sh <portrait|main|laptop>

case "$1" in
laptop)
    TARGET_DESC="BOE 0x094C"
    ;;
portrait)
    TARGET_DESC="Acer Technologies XV240Y P 0x944166C5"
    ;;
main)
    TARGET_DESC="Acer Technologies Acer XZ321QU 0x9372982E"
    ;;
*)
    echo "Usage: $0 <laptop|portrait|main>"
    exit 1
    ;;
esac

# Find the current monitor ID for this description
MONITOR_ID=$(hyprctl monitors -j | jq -r ".[] | select(.description == \"$TARGET_DESC\") | .id")

if [[ -z "$MONITOR_ID" ]]; then
    echo "Monitor with description '$TARGET_DESC' not found"
    exit 1
fi

echo "Moving workspace to $1 monitor (ID: $MONITOR_ID)"

# Move current workspace to the found monitor
hyprctl dispatch movecurrentworkspacetomonitor "$MONITOR_ID"
