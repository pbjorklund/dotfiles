# Le Dotfiles

Personal dotfiles for Linux development environments. Focused on terminal workflows with Kitty + tmux + Neovim and AI coding tools integration. **This is a personal configuration** - fork and adapt to your needs.

> [!IMPORTANT]
> **After running install**: Search and replace hardcoded paths for your username:
> 1. Open in nvim: `nvim` (or any file)
> 2. Search and replace: `,fg` then search `/home/pbjorklund` and replace with your path
>
> Many tools don't properly expand `~` so we use absolute paths. Update these to match your system. I could fix, but to lazy.

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

## Quick Start

```bash
git clone https://github.com/pbjorklund/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install dotfiles (configuration files only)
cd dotfiles && ./install.sh
```

> **For system automation**: See the separate [machine-setup](https://github.com/pbjorklund/machine-setup) repository for automated Fedora workstation setup.

## What This Provides

**Development Toolbelt**
- **CLI Workflow**: Kitty + tmux + Neovim (file-watching, auto-reload)
- **GUI Workflow**: VS Code with dark theme + extensions (roo/cline/copilot)
- **AI Coding**: Claude Code → OpenCode workflow with notification integration
- Containers, CLI utilities, development notifications via mako

## Key Features

**AI Tool Notifications**
- Requires `dev-notify.sh` (in machine-setup repo) sends desktop notifications from Claude Code, OpenCode
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

**Supported AI Tools:**
- **OpenCode** (`AGENTS.md`) - CLI coding assistant
- **Claude Desktop** (`CLAUDE.md`) - Desktop AI chat
- **Gemini CLI** (`GEMINI.md`) - Google's AI assistant
- **GitHub Copilot** (`.github/copilot-instructions.md`) - IDE integration. Also comes with custom instructions for a bunch of filetypes and langs.
- **Roo** (`.roo/rules/00-general.md`) - AI pair programming Cline fork. Quite good.

## Why These Choices

**Hyprland over i3/sway**: Better multi-monitor, active development
**tmux over screen/zellij**: Better scripting, mouse support, more features. But most of all I'm a grumpy old man set in his ways
**Neovim over vim**: Lua config, built-in LSP, better plugin ecosystem. Kinda forced into it
**Kitty over alacritty**: Better font rendering, graphics support they say. I don't really care, it works
**mako over dunst**: It's just the first I went with
