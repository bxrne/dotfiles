# Dotfiles

My dotfiles configuration organized by platform.

## Platforms

- **[Arch Linux](./archlinux/README.md)** - Hyprland, Kitty, Ranger, Waybar, Walker
- **[macOS](./macos/README.md)** - Hammerspoon, Zellij, Ghostty, Sketchybar.
- **[Common](./common/README.md)** - Neovim, Starship, Bash (shared across platforms)

## General Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/bxrne/dotfiles.git ~/dotfiles
   ```

2. Follow the platform-specific instructions in the linked READMEs above.

## Windows Note

For Windows, clone the repo and create symbolic links using PowerShell with admin privileges:
```powershell
mklink /D %USERPROFILE%\.config\nvim C:\Users\YourUsername\dotfiles\common\nvim
# Adjust paths as needed for other tools
```

