#!/bin/bash
# Hyprland Lid Switch Handler - Smart docking-aware power management
# Features: Detects external monitors, handles sleep/wake, display management
# Usage: lid-switch.sh {close|open|wake}

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
    # Look for specific external monitors using stable identifiers
    external_monitors=$(hyprctl monitors -j | jq -r '.[] | select(.description | test("Samsung Electric Company|Acer Technologies")) | .name' 2>/dev/null || true)
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
        hyprctl keyword monitor "$LAPTOP_DISPLAY,disable" 2>/dev/null || log "Warning: Failed to disable display"

        # Create a persistent state file that survives reboots
        echo "laptop_disabled_docked" >/tmp/hypr-display-state
    else
        log "No external monitors - locking screen and suspending"
        # Lock screen first (with error handling)
        if command -v swaylock >/dev/null 2>&1; then
            # Try swaylock with timeout to prevent hanging
            timeout 5s swaylock --daemonize 2>/dev/null || log "Warning: swaylock failed or timed out, continuing with suspend"
        else
            log "Warning: swaylock not found, suspending without lock"
        fi
        sleep 1
        # Then suspend system
        systemctl suspend || log "Warning: suspend command failed"
    fi
}

# Handle lid open event
handle_lid_open() {
    log "Lid opened - re-enabling laptop display"
    save_lid_state "open"

    # Always re-enable laptop display when lid opens
    hyprctl keyword monitor "$LAPTOP_DISPLAY,$LAPTOP_RESOLUTION,$LAPTOP_POSITION,$LAPTOP_SCALE" 2>/dev/null || log "Warning: Failed to enable display"

    # Clear the persistent state
    rm -f /tmp/hypr-display-state
}

# Handle wake from sleep - check if lid is closed and docked
handle_wake() {
    log "System wake detected - checking lid and dock status"
    
    # Add debouncing to prevent wake loops
    local wake_lockfile="/tmp/hypr-wake-handler.lock"
    if [[ -f "$wake_lockfile" ]]; then
        local lock_age=$(($(date +%s) - $(stat -c %Y "$wake_lockfile" 2>/dev/null || echo 0)))
        if [[ $lock_age -lt 5 ]]; then
            log "Wake handler called too recently ($lock_age seconds ago), skipping"
            return
        fi
    fi
    echo $$ >"$wake_lockfile"
    
    # Wait for system to stabilize after wake
    sleep 2

    # Check if we have a persistent state indicating laptop should be disabled
    if [[ -f "/tmp/hypr-display-state" ]] && [[ "$(cat /tmp/hypr-display-state)" == "laptop_disabled_docked" ]]; then
        log "Persistent state indicates laptop should remain disabled"
        hyprctl keyword monitor "$LAPTOP_DISPLAY,disable" 2>/dev/null || log "Warning: Failed to disable display"
        rm -f "$wake_lockfile"
        return
    fi

    if is_lid_closed && is_docked; then
        log "Woke with lid closed and docked - keeping laptop display disabled"
        hyprctl keyword monitor "$LAPTOP_DISPLAY,disable" 2>/dev/null || log "Warning: Failed to disable display"
        echo "laptop_disabled_docked" >/tmp/hypr-display-state
    elif is_lid_closed && ! is_docked; then
        log "Woke with lid closed and undocked - this shouldn't happen, enabling display"
        hyprctl keyword monitor "$LAPTOP_DISPLAY,$LAPTOP_RESOLUTION,$LAPTOP_POSITION,$LAPTOP_SCALE" 2>/dev/null || log "Warning: Failed to enable display"
        save_lid_state "open"
        rm -f /tmp/hypr-display-state
    else
        log "Woke with lid open - ensuring laptop display is enabled"
        hyprctl keyword monitor "$LAPTOP_DISPLAY,$LAPTOP_RESOLUTION,$LAPTOP_POSITION,$LAPTOP_SCALE" 2>/dev/null || log "Warning: Failed to enable display"
        rm -f /tmp/hypr-display-state
    fi
    
    rm -f "$wake_lockfile"
}

# Handle monitor hotplug events - maintain lid state
handle_hotplug() {
    log "Monitor hotplug detected - checking if lid state should be maintained"

    # If we have a persistent state indicating laptop should be disabled, maintain it
    if [[ -f "/tmp/hypr-display-state" ]] && [[ "$(cat /tmp/hypr-display-state)" == "laptop_disabled_docked" ]]; then
        log "Maintaining laptop display disabled state after hotplug"
        # Give the system a moment to detect all monitors
        sleep 1
        hyprctl keyword monitor "$LAPTOP_DISPLAY,disable"
    fi
}

# Validate parameters
[[ $# -eq 1 ]] || {
    echo "Usage: $0 {close|open|wake|hotplug}"
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
wake)
    handle_wake
    ;;
hotplug)
    handle_hotplug
    ;;
*)
    echo "Usage: $0 {close|open|wake|hotplug}"
    exit 1
    ;;
esac
