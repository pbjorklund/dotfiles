#!/bin/bash

# Script to configure USB device wakeup for sleep stability
# Disables most USB devices but allows keyboards to wake the system

echo "Configuring USB wakeup for sleep stability..."

# First, disable wakeup for all USB devices
for device in /sys/bus/usb/devices/*/power/wakeup; do
    if [ -f "$device" ]; then
        echo "disabled" >"$device" 2>/dev/null
    fi
done

# Then, selectively enable wakeup for keyboards only
keyboard_found=false
for device_path in /sys/bus/usb/devices/*/; do
    if [ -f "$device_path/power/wakeup" ] && [ -f "$device_path/bInterfaceClass" ]; then
        interface_class=$(cat "$device_path/bInterfaceClass" 2>/dev/null || echo "")

        # Check if it's a HID device (class 03)
        if [ "$interface_class" = "03" ]; then
            # Check if it's specifically a keyboard
            if [ -f "$device_path/product" ]; then
                product=$(cat "$device_path/product" 2>/dev/null || echo "")
                device_name=$(basename "$device_path")

                # Enable wakeup for keyboards (but not mice or other HID devices)
                if echo "$product" | grep -qi "keyboard"; then
                    if echo "enabled" >"$device_path/power/wakeup" 2>/dev/null; then
                        echo "Enabled keyboard wakeup for: $product"
                        keyboard_found=true
                    else
                        echo "Failed to enable wakeup for: $product"
                    fi
                else
                    echo "Disabled wakeup for non-keyboard HID device: $product"
                fi
            fi
        fi
    fi
done

if [ "$keyboard_found" = false ]; then
    echo "Warning: No keyboards found to enable wakeup for"
fi

# Disable XHCI controller wakeup to prevent spurious wake events
if [ -f /proc/acpi/wakeup ]; then
    current_xhci=$(grep "XHCI" /proc/acpi/wakeup | awk '{print $3}' 2>/dev/null || echo "")
    if [ "$current_xhci" = "enabled" ]; then
        echo "Disabling XHCI wakeup in ACPI..."
        echo XHCI >/proc/acpi/wakeup 2>/dev/null && echo "XHCI wakeup disabled" || echo "Failed to disable XHCI"
    fi
fi

echo "USB wakeup configuration complete. Keyboards can wake from sleep."

# Ensure script exits successfully
exit 0
