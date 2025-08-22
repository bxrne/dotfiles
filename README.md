# Arch Linux Dotfiles

My dotfiles configuration for Arch Linux setup, including window manager, terminal, editor, and more.

## Tools Configured

- **hypr**: Hyprland window manager configuration (compositor for wayland)
- **kitty**: Kitty terminal emulator configuration
- **ranger**: Ranger file manager configuration
- **nvim**: Neovim editor configuration
- **waybar**: Waybar status bar configuration
- **walker**: Walker application launcher configuration
- **starship**: Cross-shell prompt configuration
- **bash**: Simple shell

## Setting Up on Arch Linux

1. Install required packages via pacman:
   ```bash
   sudo pacman -S hyprland kitty ranger neovim waybar starship
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/bxrne/dotfiles.git ~/dotfiles
   ```

3. Create symbolic links to `~/.config`:
   ```bash
   ln -s ~/dotfiles/hypr ~/.config/hypr
   ln -s ~/dotfiles/kitty ~/.config/kitty
   ln -s ~/dotfiles/ranger ~/.config/ranger
   ln -s ~/dotfiles/nvim ~/.config/nvim
   ln -s ~/dotfiles/waybar ~/.config/waybar
   ln -s ~/dotfiles/walker ~/.config/walker
   ln -s ~/dotfiles/starship.toml ~/.config/starship.toml
   ln -s ~/dotfiles/.bashrc ~/.bashrc
   ```

4. Restart your session or reload configurations.

## macOS Note

For macOS users, switch to the 'macos' branch for zellij and hammerspoon configs. Use Homebrew for setup.

## Setting Up on Windows

For Windows, clone the repo and create symbolic links using PowerShell with admin privileges:
```powershell
mklink /D %USERPROFILE%\.config\nvim C:\Users\YourUsername\dotfiles\nvim
# Add similar for other tools as needed
```

