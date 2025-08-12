# DisplayLink USB-C Dock Monitor Detection Issues on Wayland

## Issue Summary

**Problem**: Dell U2419HC monitor connected through USB-C docking station fails to be detected by Wayland compositor niri, it's detected and can run non electron apps in Hyprland, but works fine in GNOME/Wayland. Additionally, Electron applications crash when moved to the Dell monitor in Hyprland.

**Root Cause**: GNOME/Mutter has superior DisplayLink/EVDI integration and EDID fallback mechanisms compared to other Wayland compositors like niri and Hyprland.

## Hardware Setup

- **Laptop**: ThinkPad with Intel Raptor Lake-P Iris Xe Graphics
- **Monitors**:
  - Built-in laptop display (eDP-1): 1920x1200@60Hz
  - Samsung S24F350 (DP-3): 1920x1080@60Hz ✅ **Working**
  - Dell U2419HC (DVI-I-1): 1920x1080@60Hz ❌ **Not detected**
- **Connection**: USB-C docking station
- **OS**: Fedora 42 with kernel 6.15.3

## Technical Analysis

### EDID Data Investigation

```bash
# EDID file sizes - Dell monitor has 0 bytes (corrupted/missing)
-r--r--r--. 1 root root 0 28 jun 15.08 /sys/class/drm/card0/card0-DVI-I-1/edid  # Dell - BROKEN
-r--r--r--. 1 root root 256 28 jun 15.08 /sys/class/drm/card1/card1-DP-3/edid   # Samsung - OK
-r--r--r--. 1 root root 128 28 jun 15.08 /sys/class/drm/card1/card1-eDP-1/edid  # Laptop - OK
```

### DisplayLink/EVDI Driver Status

```bash
# EVDI version installed
evdi/1.14.10, 6.14.11-300.fc42.x86_64, x86_64: installed
evdi/1.14.10, 6.15.3-200.fc42.x86_64, x86_64: installed

# Kernel logs show EVDI activity but no proper EDID
evdi: [I] (card0) Edid property set
evdi: [E] evdi_painter_connect:871 Edid length too small
```

# DisplayLink USB-C Dock Issues on Wayland

## ✅ SOLUTION FOUND (June 28, 2025)

**Root Cause**: XWayland incompatibility with DisplayLink virtual displays causes SIGILL crashes in Electron apps.

**Working Solution**: Force Electron apps to use X11 backend instead of auto-detection.

### 🎯 Fix Implementation

**1. System-wide Electron apps** (VS Code, etc.):

```bash
# In Hyprland environment config
env = ELECTRON_OZONE_PLATFORM_HINT,x11
```

**2. Flatpak Electron apps** (Obsidian, etc.):

```bash
# Set environment variable and disable Wayland socket
flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=x11 --nosocket=wayland md.obsidian.Obsidian
```

**3. Automated via System Setup**:
See the [ansible-fedora](https://github.com/pbjorklund/ansible-fedora) repository for automated Flatpak configuration.

### ✅ Confirmed Working

- **VS Code**: ✅ Works on all monitors including DisplayLink
- **Obsidian (Flatpak)**: ✅ Works on all monitors including DisplayLink
- **All DisplayLink monitors**: ✅ Functional in Hyprland for both native and Electron apps

## Problem Summary

Dell U2419HC monitor connected through USB-C docking station:

- ❌ **Not detected in niri** - completely missing from compositor
- ⚠️ **Works in Hyprland** - but Electron apps crash on DisplayLink monitor
- ✅ **Works perfectly in GNOME** - all 3 monitors functional

## Root Cause Analysis

**This is a DisplayLink integration problem, not hardware failure.**

### Key Evidence

- **Direct HDMI connection**: Dell monitor works perfectly in niri
- **GDM handoff issue**: Login screen (GDM) shows monitors, then they disappear in niri
- **Kernel detection**: DRM subsystem sees connection (`card0-DVI-I-1: connected`) but EDID is 0 bytes
- **Compositor gap**: GNOME/Mutter has superior DisplayLink integration vs smaller compositors

### Why GNOME Works but niri/Hyprland Don't

**GNOME/Mutter advantages**:

- Advanced DisplayLink/EVDI integration built-in
- EDID fallback mechanisms for virtual displays
- Years of enterprise display compatibility work

**niri/Hyprland limitations**:

- Direct DRM dependency without DisplayLink abstraction layer
- No fallback for missing/corrupted EDID from virtual displays
- Focus on simplicity over comprehensive hardware compatibility

## Hardware Setup

- **Laptop**: ThinkPad with Intel Raptor Lake-P Iris Xe Graphics
- **Dock**: USB-C with DisplayLink (creates virtual displays via EVDI driver)
- **Monitors**: Laptop (eDP-1) + Samsung (DP-3) + Dell (DVI-I-1)
- **OS**: Fedora 42, EVDI 1.14.10

## What We Tried

> See `docs/displaylink-fix-attempts.md` for detailed log

### ❌ Wrong Approaches (Reverted)

- **Custom EDID injection**: Created Dell monitor EDID and kernel parameters
- **GRUB modifications**: Added `drm.edid_firmware=DVI-I-1:edid/dell_u2419hc.bin`
- **Reason reverted**: Direct HDMI works fine, so EDID is not corrupted

### ✅ Successful Fixes

- **niri configuration**: Samsung monitor now properly positioned
- **Monitor detection script**: Created diagnostic tool (`scripts/monitor-detection-helper.sh`)

### 🔍 External Research

**Arch Linux BBS Thread Investigation** (January 2025):

- **Thread**: #302762 "Electron apps crashing on Wayland"
- **Their issue**: SIGSEGV crashes due to broken cursor theme configuration
- **Their solution**: Fixed cursor theme settings in `~/.config/gtk-3.0/settings.ini`, `~/.gtkrc-2.0`, `~/.config/xsettingsd/xsettingsd.conf`
- **Our assessment**: **Not relevant** - their crashes were SIGSEGV (segmentation fault), ours are SIGILL (illegal instruction). Their issue was cursor-related, ours is DisplayLink-specific and only occurs when DisplayLink monitors are active.

### ❌ Failed Attempts

- DRM rescans, EVDI driver reloads, kernel parameter injection

## Related Issues

Multiple open GitHub issues confirm this is a widespread problem:

- [DisplayLink/evdi#484](https://github.com/DisplayLink/evdi/issues/484): "Monitors blank on Wayland"
- [DisplayLink/evdi#508](https://github.com/DisplayLink/evdi/issues/508): "Edid length too small"
- [hyprwm/Hyprland#7292](https://github.com/hyprwm/Hyprland/issues/7292): "DisplayLink dock no signal"

**Status**: No official fix available as of June 2025

## Current Status (June 28, 2025)

### ✅ Confirmed Working

- **GNOME/Wayland**: All 3 monitors fully functional
- **Hyprland**: All 3 monitors detected and working for non-Electron apps
- **Direct HDMI**: Dell monitor works perfectly in niri when connected directly

### ❌ Confirmed Issues

- **niri**: Dell monitor (DVI-I-2) not detected at all
- **Hyprland**: **Electron apps crash when moved to DisplayLink monitors** (confirmed with Obsidian)

### 🔍 Technical Findings

**Current Monitor Mapping**:

- `eDP-1`: Laptop screen (1920x1200) - ✅ Works everywhere
- `DVI-I-1`: Samsung S24F350 (1920x1080) - ✅ Works in Hyprland, niri
- `DVI-I-2`: Dell U2419HC (1920x1080) - ⚠️ Works in Hyprland (non-Electron only), ❌ Not detected in niri

**Electron App Testing**:

- **Test app**: Obsidian (Flatpak md.obsidian.Obsidian)
- **Result**: Crashes on startup with `SIGILL` (illegal instruction) in DisplayLink environment
- **Crash pattern**: Multiple core dumps show crashes at `/app/obsidian + 0x3023431`
- **Root cause**: Hardware acceleration incompatibility - Electron trying to execute unsupported CPU instructions
- **Impact**: Electron apps cannot run at all in Hyprland when DisplayLink monitors are active

### 💥 Detailed Crash Analysis

**Core dump analysis** (June 28, 2025):

```bash
# Multiple crashes with SIGILL (illegal instruction)
sudo coredumpctl list obsidian --since today
TIME                           PID  UID  GID SIG    COREFILE EXE           SIZE
Sat 2025-06-28 16:23:51 CEST  3417 1000 1000 SIGILL present  /app/obsidian 9.1M
Sat 2025-06-28 16:27:11 CEST 16805 1000 1000 SIGILL present  /app/obsidian 9.3M
Sat 2025-06-28 16:28:14 CEST 18283 1000 1000 SIGILL present  /app/obsidian 9.2M

# Stack trace shows crash in graphics/rendering code
Stack trace of thread 14:
#0  0x0000565213818431 n/a (/app/obsidian + 0x3023431)
#1  0x000056521383000c n/a (/app/obsidian + 0x303b00c)
#2  0x0000565212b9a795 n/a (/app/obsidian + 0x23a5795)
```

**Key insight**: The issue is worse than initially thought:

- Electron apps crash **on startup**, not just when moved to DisplayLink monitors
- `SIGILL` indicates CPU instruction incompatibility, likely in graphics/GPU acceleration code
- **XWayland + DisplayLink incompatibility**: Electron apps run via XWayland, which has poor DisplayLink integration
- DisplayLink's virtual display drivers interfere with XWayland's graphics acceleration
- This affects **all Electron apps** when DisplayLink monitors are connected
- **Tested GPU acceleration disabling**: All known GPU disable flags were tried without success
- **Tested native Wayland**: Forcing `ELECTRON_OZONE_PLATFORM_HINT=wayland` still crashes

### 🔍 XWayland + DisplayLink Root Cause

The core issue appears to be **XWayland's incompatibility with DisplayLink virtual displays**:

1. **Electron apps default to XWayland** (not native Wayland)
2. **XWayland has poor DisplayLink support** compared to native Wayland compositors
3. **Graphics acceleration conflicts** occur between XWayland and DisplayLink's EVDI driver
4. **Virtual display GPU context issues** cause illegal instruction crashes

This explains why:

- ✅ **GNOME works**: Native Wayland apps + superior DisplayLink integration
- ❌ **Hyprland fails with Electron**: XWayland + DisplayLink = crashes
- ❌ **Even GPU acceleration disabled**: Issue is deeper in XWayland/DisplayLink interaction

## Recommended Solutions

### Short-term Workarounds

1. **Use GNOME** for full DisplayLink support (native Wayland apps work)
2. **Disconnect DisplayLink monitors** when using Electron apps in Hyprland
3. **Direct HDMI connection** for Dell monitor in niri (bypasses DisplayLink)
4. **Use web versions** of Electron apps (browser-based, not XWayland)

### Long-term Solutions

1. **Monitor XWayland DisplayLink improvements** - this is an upstream XWayland/DisplayLink compatibility issue
2. **Track Electron native Wayland adoption** - newer Electron versions have better Wayland support
3. **Consider DisplayLink alternatives** - USB-C hubs with native DP/HDMI (no virtual displays)
4. **Contribute to upstream projects** with detailed XWayland/DisplayLink bug reports

### Technical Recommendations

1. **Report to XWayland developers** - this is primarily an XWayland+DisplayLink integration bug
2. **Report to DisplayLink** - EVDI driver may need XWayland compatibility fixes
3. **Track Electron Ozone progress** - native Wayland backend may resolve this
4. **Monitor wlroots-based compositor improvements** - better DisplayLink support over time
