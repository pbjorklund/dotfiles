# Wallpaper Management System

## Swaybg-based Multi-Monitor Wallpaper Management

The wallpaper system uses `swaybg` with a custom management script for multi-monitor support and wallpaper cycling.

### Migration Status: ✅ COMPLETE

- ✅ Migrated from hyprpaper to swaybg
- ✅ All wallpapers moved from archive folder
- ✅ Multi-monitor support implemented
- ✅ Support for jpg, jpeg, png, webp formats

### Changes Made

1. **Replaced hyprpaper with swaybg** in Ansible playbook
2. **Created wallpaper-manager.sh script** for multi-monitor support
3. **Updated keybinds** for wallpaper management
4. **Maintained monitor-specific wallpaper mappings**
5. **Moved all archived wallpapers** to main directory
6. **Added support** for jpg, jpeg, png, webp formats

### Wallpaper Management Script

**Location:** `~/.config/hypr/scripts/wallpaper-manager.sh`

**Usage:**
```bash
# Start/reload wallpapers (monitor-specific)
./wallpaper-manager.sh start
./wallpaper-manager.sh reload

# Set specific wallpaper for all monitors
./wallpaper-manager.sh set main.jpg

# Cycle through available wallpapers
./wallpaper-manager.sh cycle
```

### Keybinds

| Key Combination | Action |
|----------------|--------|
| `Super + Alt + W` | Reload wallpapers (monitor-specific) |
| `Super + Alt + N` | Cycle through wallpapers |

### Monitor Mappings

The script maintains monitor-specific wallpaper mappings:

- **Samsung Electric Company SE790C** (43" ultrawide): `work.jpg`
- **DVI-I-2** (32" Acer monitor): `main.jpg`  
- **DVI-I-1** (27" Acer portrait): `portrait.jpg`
- **Default/Other monitors**: `main.jpg`

### Adding Wallpapers

1. Place wallpaper files (`.jpg`, `.jpeg`, `.png`, or `.webp`) in `~/.config/hypr/wallpapers/`
2. Run `./wallpaper-manager.sh reload` or use `Super + Alt + W`

### Available Wallpapers

Currently available wallpapers (moved from archive):
- `main.jpg`, `main2.webp`, `main3.webp`, `main4.png`
- `work.jpg`
- `portrait.jpg`, `portrait2.jpg`, `portrait3.jpg`, `portrait4.jpg`, `portrait5.jpg`

### Advantages of swaybg

- ✅ Available in main Fedora repositories
- ✅ No dependency conflicts
- ✅ Per-monitor wallpaper support (via script)
- ✅ Lightweight and fast
- ✅ Compatible with all Wayland compositors

### Dependencies

- `swaybg` - Wallpaper daemon
- `jq` - JSON processor for monitor detection
- `hyprctl` - Hyprland control utility
