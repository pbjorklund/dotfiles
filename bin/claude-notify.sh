#!/bin/bash

# Claude Code notification script for mako
# This script receives JSON input from Claude Code notification hooks
# and formats it properly for mako desktop notifications

# Read JSON input from stdin
input=$(cat)

# Parse the notification message and session info
message=$(echo "$input" | jq -r '.message // "Claude Code notification"')
session_id=$(echo "$input" | jq -r '.session_id // "unknown"')
hook_event=$(echo "$input" | jq -r '.hook_event_name // "notification"')

# Determine notification urgency and icon based on message content
urgency="normal"
icon="dialog-information"
timeout=5000

# Customize notification based on message content
if echo "$message" | grep -qi "permission"; then
    urgency="critical"
    icon="dialog-warning"
    timeout=0  # Don't auto-dismiss permission requests
elif echo "$message" | grep -qi "waiting.*input"; then
    urgency="normal"
    icon="dialog-question"
    timeout=10000
elif echo "$message" | grep -qi "error\|fail"; then
    urgency="critical"
    icon="dialog-error"
    timeout=8000
elif echo "$message" | grep -qi "complete\|done\|success"; then
    urgency="low"
    icon="dialog-information"
    timeout=3000
fi

# Format the title
title="Claude Code"
if [ "$session_id" != "unknown" ]; then
    # Show last 8 characters of session ID
    short_session=$(echo "$session_id" | tail -c 9)
    title="Claude Code ($short_session)"
fi

# Send notification to mako
notify-send "$title" "$message" \
    -u "$urgency" \
    -i "$icon" \
    -t "$timeout" \
    -a "claude-code" \
    -c "claude"

# Log the notification for debugging (optional)
if [ "${CLAUDE_NOTIFY_DEBUG:-}" = "1" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [Claude Notify] $hook_event: $message" >> ~/.claude/notifications.log
fi