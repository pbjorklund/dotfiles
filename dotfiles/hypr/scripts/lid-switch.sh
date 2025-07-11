#!/bin/bash
# Hyprland Lid Switch Handler - Smart display management for docking
# Features: Detects external monitors, handles display enable/disable
# Usage: lid-switch.sh {close|open}

set -euo pipefail

# Configuration
readonly LAPTOP_DISPLAY="eDP-1"
readonly LAPTOP_RESOLUTION="1920x1200@60"
readonly LAPTOP_POSITION="4480x0"
readonly LAPTOP_SCALE="1.2"
readonly LID_STATE_FILE="/tmp/hypr-lid-state"

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | systemd-cat -t hypr-lid-switch
}

# Check if external monitors are connected (docked)
is_docked() {
    local external_monitors
    external_monitors=$(hyprctl monitors -j | jq -r '.[] | select(.name != "'"$LAPTOP_DISPLAY"'") | .name' 2>/dev/null || true)
    [[ -n "$external_monitors" ]]
}

# Check if lid is currently closed
is_lid_closed() {
    [[ -f "$LID_STATE_FILE" ]] && [[ "$(cat "$LID_STATE_FILE")" == "closed" ]]
}

# Save lid state for wake-from-sleep detection
save_lid_state() {
    local state="$1"
    echo "$state" >"$LID_STATE_FILE"
}

# Handle lid close event
handle_lid_close() {
    log "Lid closed - checking dock status"
    save_lid_state "closed"

    if is_docked; then
        log "External monitors detected - disabling laptop display only"
        hyprctl keyword monitor "$LAPTOP_DISPLAY,disable"
    else
        log "No external monitors - disabling laptop display (hypridle will handle sleep)"
        hyprctl keyword monitor "$LAPTOP_DISPLAY,disable"
    fi
}

# Handle lid open event
handle_lid_open() {
    log "Lid opened - re-enabling laptop display"
    save_lid_state "open"

    # Always re-enable laptop display when lid opens
    hyprctl keyword monitor "$LAPTOP_DISPLAY,$LAPTOP_RESOLUTION,$LAPTOP_POSITION,$LAPTOP_SCALE"
}

# Validate parameters
[[ $# -eq 1 ]] || {
    echo "Usage: $0 {close|open}"
    exit 1
}

# Main execution
case "$1" in
close)
    handle_lid_close
    ;;
open)
    handle_lid_open
    ;;
*)
    echo "Usage: $0 {close|open}"
    exit 1
    ;;
esac
