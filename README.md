# Le Dotfiles

Automated Fedora workstation setup using modular Ansible playbooks and dotfiles. **This is a personal configuration** - fork and adapt to your needs.

## My Development Workflow

**Primary Setup**: Kitty terminal + tmux + CLI-agentic-coding-tools
- Start with Claude Code (until usage ceiling)
- Switch to OpenCode (GitHub Copilot subscription limits)
- Neovim monitors file changes from CLI LLMs and auto-reloads
- Custom tmux styling with activity indicators and workspace management

**Secondary Setup**: VS Code with extensions
- Roo/Cline/GitHub Copilot integration
- Dark theme configuration matching terminal aesthetic
- Used for GUI-heavy tasks and extension-dependent workflows

**Why Ansible**: Documents complex setup procedures (DisplayLink drivers, fingerprint auth, hardware quirks) that would otherwise require hours of research and trial-and-error.

## Quick Start

```bash
git clone https://github.com/pbjorklund/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Full automated setup (recommended for new systems)
ansible-playbook ansible/workstation-setup.ansible.yml

# Selective setup - common tag combinations:
ansible-playbook ansible/workstation-setup.ansible.yml --tags security,development
ansible-playbook ansible/workstation-setup.ansible.yml --tags desktop,privacy

# Configuration files only
cd dotfiles && ./install.sh
```

## What This Provides

**Core System** (`security`, `base`)
- SSH key management, 1Password CLI, GitHub authentication
- Essential development tools and system hardening

**Development Toolbelt** (`development`)
- **CLI Workflow**: Kitty + tmux + Neovim (file-watching, auto-reload)
- **GUI Workflow**: VS Code with dark theme + extensions (roo/cline/copilot)
- **AI Coding**: Claude Code → OpenCode workflow with notification integration
- Containers, CLI utilities, development notifications via mako

**Desktop Environment** (`desktop`, `hyprland`)
- Hyprland with custom workspace management or GNOME fallback
- SDDM display manager, styled consistently with terminal theme
- Application suite, browser configuration

**Hardware Support** (`hardware`)
- ThinkPad fingerprint authentication setup (complex, now automated)
- DisplayLink drivers configuration (notoriously difficult, now documented)
- Power management and device-specific optimizations

## File Structure (What Goes Where)

```
ansible/                    # System automation - run these to set up your machine
├── workstation-setup.yml   # Master playbook that runs everything
├── base-system.yml         # Core packages, users, basic config
├── development-tools.yml   # Languages, editors, containers
├── hyprland-desktop.yml    # Wayland desktop environment
└── hardware-*.yml          # Device-specific stuff (fingerprint, displaylink)

dotfiles/                   # Personal config files
├── install.sh             # Symlinks everything to ~/.config, ~/.*
├── nvim/                  # Neovim config with file watching
├── tmux/                  # Styled tmux with activity indicators
├── hypr/                  # Hyprland window manager config
└── shell/                 # bash/zsh aliases, functions

bin/                       # Custom scripts that go in PATH
├── pbproject              # Project templates and initialization
└── dev-notify.sh          # Notification bridge for AI coding tools

project-templates/         # Starter configs for new projects
└── .github/instructions/  # AI assistant context for different tools
```

## Key Features You Should Know About

**Notifications That Actually Work**
- `dev-notify.sh` sends desktop notifications from Claude Code, OpenCode
- Shows in mako (Wayland) with proper icons and persistence
- No more missing that the AI finished your request

**Smart File Watching**
- Neovim auto-reloads when external tools modify files
- Works great with CLI AI tools that edit multiple files
- No more "file changed on disk" prompts

**Hyprland Workspace Management**
- Workspaces follow monitors (workspace 1 always on main display)
- Scripts for moving workspaces between monitors
- Keybinds for common window management tasks

**Development Project Setup**
- `pbproject` creates new projects from templates
- Templates include proper .github/instructions for AI assistants
- Consistent structure across all projects

## Customization (Making It Yours)

**Personal Data Placeholders**
- Replace "Your Name" in git config
- Update email addresses from example.com
- Change SSH key paths in security configs

**Color Schemes and Styling**
- Consistent dark theme across kitty, tmux, VS Code
- Modify `dotfiles/*/` configs for different colors
- Hyprland uses custom wallpapers in `dotfiles/hypr/wallpapers/`

**Hardware-Specific Stuff**
- Skip hardware playbooks if you don't have ThinkPad/DisplayLink
- Monitor configs in `dotfiles/hypr/conf/monitors.conf`
- Power management might need tweaking for different laptops

## Common Issues and Gotchas

**First Run Problems**
- Some playbooks need internet (they download packages)
- 1Password CLI needs manual auth on first setup
- DisplayLink requires a reboot to work properly

**Desktop Environment Conflicts**
- Don't run both GNOME and Hyprland tags together
- SDDM will override GDM if both are installed
- Some GNOME apps work weird under Hyprland

**Development Tools**
- VS Code extensions install automatically but need manual config
- Docker needs your user in the docker group (logout/login required)
- Some containers need SELinux tweaks on Fedora

**File Permissions**
- Scripts in `bin/` need to be executable
- SSH keys need proper permissions (600)
- Some systemd user services need manual enable

## Testing Changes

```bash
# Always lint before running
ansible-lint ansible/*.yml

# Test syntax without making changes
ansible-playbook --syntax-check ansible/workstation-setup.yml

# Run specific parts
ansible-playbook ansible/workstation-setup.yml --tags development --check

# See what would change without doing it
ansible-playbook ansible/workstation-setup.yml --check --diff
```

## Why These Choices

**Ansible over shell scripts**: Idempotent, handles errors, self-documenting
**Hyprland over i3/sway**: Better multi-monitor, active development
**tmux over screen**: Better scripting, mouse support, more features
**Neovim over vim**: Lua config, built-in LSP, better plugin ecosystem
**Kitty over alacritty**: Better font rendering, graphics support
**mako over dunst**: Wayland native, better integration

## Requirements

- Fedora Linux with sudo access
- Ansible (`dnf install ansible`)
- Internet connection for package downloads
- Some patience for first run (takes 10-15 minutes)
