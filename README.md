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
├── pbproject              # AI-optimized project initialization and templates
├── llm-link               # Unified LLM instruction management across projects
└── dev-notify.sh          # Notification bridge for AI coding tools

project-templates/         # Starter configs for new projects with AI support
├── LLM_CORE_SYSTEM_PROMPT.md  # Unified system prompt for all AI tools
├── AGENTS.md|CLAUDE.md|GEMINI.md  # Symlinks to core prompt for each tool
├── github/instructions/   # GitHub Copilot context and workflow templates
└── roo/rules/            # Roo AI assistant rules and configuration
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

**AI-Optimized Project Setup**
- `pbproject` creates new projects with shared LLM instructions
- `llm-link` manages AI tool configurations across projects
- Templates include proper context for Claude, OpenCode, Copilot, Roo, Gemini

## Project Management Tools

### pbproject - AI-Optimized Project Initialization

Creates new projects with consistent structure and shared AI tool configurations.

```bash
# Create new project with LLM setup
pbproject init my-new-project

# Create project at specific location
pbproject init my-app ~/projects/my-app

# Check current project status
pbproject status

# Detach symlinks to create independent copies
pbproject detach

# Migrate folder from existing project to new standalone project
pbproject migrate batch_writer ~/Projects/cli-tool

# Create private GitHub repository for current project
pbproject newghrepo
```

**What it provides:**
- **Unified LLM instructions**: All AI tools share the same system prompt
- **Auto-updating templates**: Symlinked configs get improvements automatically
- **Easy customization**: Detach to independent copies when needed
- **GitHub integration**: Automatic private repo creation and push

### llm-link - Baseline AI Configuration Setup

Symlinks in generic LLM instruction files across all supported AI coding tools. All based on the same core prompt. Can detach to create independent copies for customization.

```bash
# Set up LLM files in current directory
llm-link

# Check status of LLM files
llm-link --status

# Convert symlinks to independent copies for customization
llm-link --detach
```

**Supported AI Tools:**
- **OpenCode** (`AGENTS.md`) - CLI coding assistant
- **Claude Desktop** (`CLAUDE.md`) - Desktop AI chat
- **Gemini CLI** (`GEMINI.md`) - Google's AI assistant
- **GitHub Copilot** (`.github/copilot-instructions.md`) - IDE integration. Also comes with custom instructions for a bunch of filetypes and langs.
- **Roo** (`.roo/rules/00-general.md`) - AI pair programming Cline fork. Quite good.

**Workflow:**
1. **Start new project**: `pbproject init` creates project with symlinked LLM configs
2. **Develop**: All AI tools share unified instructions and coding standards
3. **Customize when needed**: `llm-link --detach` creates independent copies
4. **Update shared configs**: Changes to templates automatically propagate to linked projects

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

## Why These Choices

**Ansible over shell scripts**: Idempotent, handles errors, self-documenting
**Hyprland over i3/sway**: Better multi-monitor, active development
**tmux over screen/zellij**: Better scripting, mouse support, more features. But most of all I'm a grumpy old man set in his ways
**Neovim over vim**: Lua config, built-in LSP, better plugin ecosystem. Kinda forced into it
**Kitty over alacritty**: Better font rendering, graphics support they say. I don't really care, it works
**mako over dunst**: It's just the first I went with

## Requirements

- Fedora Linux with sudo access
- Ansible (`dnf install ansible`)
- Internet connection for package downloads
- Some patience for first run (takes 10-15 minutes)

