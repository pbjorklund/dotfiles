#!/bin/bash
# Bluetooth Management Script for Hyprland
# Provides quick toggle and device management functionality

set -euo pipefail

# Function to show notification
notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Bluetooth" "$1" -i bluetooth
    fi
}

# Function to get Bluetooth power status
get_power_status() {
    local power_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
    if [[ "$power_status" == "yes" ]]; then
        echo "on"
    else
        echo "off"
    fi
}

# Function to toggle Bluetooth power
toggle_power() {
    local current_status=$(get_power_status)

    if [[ "$current_status" == "on" ]]; then
        bluetoothctl power off
        notify "Bluetooth disabled"
        echo "Bluetooth disabled"
    else
        bluetoothctl power on
        notify "Bluetooth enabled"
        echo "Bluetooth enabled"
    fi
}

# Function to list available devices
list_devices() {
    echo "=== Paired Devices ==="
    bluetoothctl paired-devices
    echo
    echo "=== Available Devices ==="
    bluetoothctl devices
}

# Function to start scanning
start_scan() {
    bluetoothctl scan on &
    SCAN_PID=$!
    notify "Bluetooth scanning started"
    echo "Scanning for devices... (Ctrl+C to stop)"
    sleep 10
    kill $SCAN_PID 2>/dev/null || true
    bluetoothctl scan off
    notify "Bluetooth scanning stopped"
}

# Function to connect to a device
connect_device() {
    local mac_address="$1"

    if bluetoothctl connect "$mac_address"; then
        notify "Connected to device"
        echo "Connected to $mac_address"
    else
        notify "Failed to connect to device"
        echo "Failed to connect to $mac_address"
    fi
}

# Function to disconnect a device
disconnect_device() {
    local mac_address="$1"

    if bluetoothctl disconnect "$mac_address"; then
        notify "Disconnected from device"
        echo "Disconnected from $mac_address"
    else
        notify "Failed to disconnect from device"
        echo "Failed to disconnect from $mac_address"
    fi
}

# Function to pair with a device
pair_device() {
    local mac_address="$1"

    echo "Pairing with $mac_address..."
    if bluetoothctl pair "$mac_address"; then
        notify "Device paired successfully"
        echo "Paired with $mac_address"

        # Trust the device automatically
        bluetoothctl trust "$mac_address"
        echo "Device trusted"
    else
        notify "Failed to pair with device"
        echo "Failed to pair with $mac_address"
    fi
}

# Function to show connected devices
show_connected() {
    echo "=== Connected Devices ==="
    bluetoothctl devices Connected
}

# Function to show quick device menu using wofi
quick_menu() {
    if ! command -v wofi >/dev/null 2>&1; then
        echo "Error: wofi not found. Install wofi for quick menu functionality."
        return 1
    fi

    local options="Toggle Power\nOpen GNOME Settings\nOpen Blueman\nScan for Devices\nShow Connected\nShow All Devices"
    local choice=$(echo -e "$options" | wofi --dmenu --prompt "Bluetooth:")

    case "$choice" in
    "Toggle Power")
        toggle_power
        ;;
    "Open GNOME Settings")
        gnome-control-center bluetooth &
        ;;
    "Open Blueman")
        if command -v blueman-manager >/dev/null 2>&1; then
            blueman-manager &
        else
            notify "Blueman not installed, opening GNOME Settings"
            gnome-control-center bluetooth &
        fi
        ;;
    "Scan for Devices")
        start_scan
        ;;
    "Show Connected")
        show_connected | wofi --dmenu --prompt "Connected:"
        ;;
    "Show All Devices")
        list_devices | wofi --dmenu --prompt "Devices:"
        ;;
    esac
}

# Main script logic
case "${1:-help}" in
"toggle" | "t")
    toggle_power
    ;;
"on")
    bluetoothctl power on
    notify "Bluetooth enabled"
    ;;
"off")
    bluetoothctl power off
    notify "Bluetooth disabled"
    ;;
"scan" | "s")
    start_scan
    ;;
"list" | "l")
    list_devices
    ;;
"connected" | "c")
    show_connected
    ;;
"connect")
    if [[ $# -lt 2 ]]; then
        echo "Usage: $0 connect <MAC_ADDRESS>"
        exit 1
    fi
    connect_device "$2"
    ;;
"disconnect")
    if [[ $# -lt 2 ]]; then
        echo "Usage: $0 disconnect <MAC_ADDRESS>"
        exit 1
    fi
    disconnect_device "$2"
    ;;
"pair")
    if [[ $# -lt 2 ]]; then
        echo "Usage: $0 pair <MAC_ADDRESS>"
        exit 1
    fi
    pair_device "$2"
    ;;
"menu" | "m")
    quick_menu
    ;;
"gui")
    if command -v gnome-control-center >/dev/null 2>&1; then
        gnome-control-center bluetooth &
    elif command -v blueman-manager >/dev/null 2>&1; then
        blueman-manager &
    else
        echo "No GUI Bluetooth manager found"
        exit 1
    fi
    ;;
"gnome")
    gnome-control-center bluetooth &
    ;;
"blueman")
    if command -v blueman-manager >/dev/null 2>&1; then
        blueman-manager &
    else
        echo "Blueman not installed"
        exit 1
    fi
    ;;
"status")
    echo "Bluetooth status: $(get_power_status)"
    show_connected
    ;;
"help" | "h" | *)
    echo "Bluetooth Management Script for Hyprland"
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  toggle, t          Toggle Bluetooth power"
    echo "  on                 Turn Bluetooth on"
    echo "  off                Turn Bluetooth off"
    echo "  scan, s            Scan for available devices"
    echo "  list, l            List all devices"
    echo "  connected, c       Show connected devices"
    echo "  connect <MAC>      Connect to device by MAC address"
    echo "  disconnect <MAC>   Disconnect device by MAC address"
    echo "  pair <MAC>         Pair with device by MAC address"
    echo "  menu, m            Show interactive menu (requires wofi)"
    echo "  gui                Open GUI (GNOME Settings or Blueman)"
    echo "  gnome              Open GNOME Bluetooth settings"
    echo "  blueman            Open Blueman manager"
    echo "  status             Show current status"
    echo "  help, h            Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 toggle                    # Toggle Bluetooth power"
    echo "  $0 scan                      # Scan for devices"
    echo "  $0 pair 00:11:22:33:44:55   # Pair with device"
    echo "  $0 menu                      # Show interactive menu"
    ;;
esac
