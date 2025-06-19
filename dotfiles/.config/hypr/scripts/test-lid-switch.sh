#!/bin/bash
# Test script for Hyprland lid switch functionality

echo "=== Hyprland Lid Switch Test ==="

echo "1. Checking if lid state file exists:"
if [[ -f /tmp/hypr-lid-state ]]; then
    echo "   Lid state: $(cat /tmp/hypr-lid-state)"
else
    echo "   No lid state file found"
fi

echo "2. Checking if display state file exists:"
if [[ -f /tmp/hypr-display-state ]]; then
    echo "   Display state: $(cat /tmp/hypr-display-state)"
else
    echo "   No display state file found"
fi

echo "3. Current monitor configuration:"
hyprctl monitors | grep -E "(Monitor|disabled)" || echo "   Failed to get monitor info"

echo "4. External monitors detected:"
external=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' 2>/dev/null || true)
if [[ -n "$external" ]]; then
    echo "   $external"
else
    echo "   None"
fi

echo "5. Services status:"
echo "   Resume monitor: $(systemctl --user is-active hyprland-resume-monitor.service)"

echo "6. Recent lid events:"
journalctl -u systemd-logind --since "10 minutes ago" | grep -i "lid" | tail -3 || echo "   No recent lid events"

echo "=== Test Complete ==="
