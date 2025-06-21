#!/bin/bash

# Script to disable USB device wakeup to prevent immediate wake from sleep
# This prevents USB mice, keyboards, and other devices from waking the laptop

echo "Disabling USB wakeup for sleep stability..."

# Disable wakeup for all USB devices except essential ones
for device in /sys/bus/usb/devices/*/power/wakeup; do
    if [ -f "$device" ]; then
        device_path=$(dirname "$device")
        device_name=$(basename "$device_path")

        # Check if it's a real USB device (not root hub)
        if [ -f "$device_path/product" ]; then
            product=$(cat "$device_path/product" 2>/dev/null || echo "Unknown")
            current_state=$(cat "$device" 2>/dev/null || echo "unknown")

            # Disable wakeup for this device
            if [ "$current_state" = "enabled" ]; then
                echo "disabled" >"$device" 2>/dev/null &&
                    echo "Disabled wakeup for $device_name: $product" ||
                    echo "Failed to disable wakeup for $device_name: $product"
            fi
        fi
    fi
done

# Also disable XHCI controller wakeup (USB 3.0 controller)
if [ -f /proc/acpi/wakeup ]; then
    echo "Disabling XHCI wakeup in ACPI..."
    echo XHCI >/proc/acpi/wakeup 2>/dev/null && echo "XHCI wakeup disabled" || echo "Failed to disable XHCI"
fi

echo "USB wakeup configuration complete."
