#!/bin/bash
# Move workspace to monitor by stable identifier - dynamically finds monitor name
# Usage: move-workspace-to-monitor.sh <portrait|main|laptop>

# Function to find current connector name by monitor description
find_monitor_connector() {
    local target_desc="$1"
    hyprctl monitors -j | jq -r ".[] | select(.description == \"$target_desc\") | .name"
}

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

# Find the current monitor name (connector) for this description
MONITOR_NAME=$(find_monitor_connector "$TARGET_DESC")

if [[ -z "$MONITOR_NAME" ]]; then
    echo "Monitor with description '$TARGET_DESC' not found"
    exit 1
fi

echo "Moving workspace to $1 monitor ($MONITOR_NAME)"

# Move current workspace to the found monitor using the monitor name
hyprctl dispatch movecurrentworkspacetomonitor "$MONITOR_NAME"
