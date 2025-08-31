# Arch Linux Setup

This folder contains configurations for Arch Linux specific tools: Hyprland, Kitty, Ranger, Waybar, and Walker.

## Prerequisites

- Arch Linux installed

## Installation

1. Install required packages:
   ```bash
   sudo pacman -S hyprland kitty ranger neovim waybar starship
   ```

2. Clone the repository (if not already):
   ```bash
   git clone https://github.com/bxrne/dotfiles.git ~/dotfiles
   ```

3. Create symbolic links:
   ```bash
   ln -s ~/dotfiles/archlinux/hypr ~/.config/hypr
   ln -s ~/dotfiles/archlinux/kitty ~/.config/kitty
   ln -s ~/dotfiles/archlinux/ranger ~/.config/ranger
   ln -s ~/dotfiles/archlinux/waybar ~/.config/waybar
   ln -s ~/dotfiles/archlinux/walker ~/.config/walker
   ```

4. For common configurations (Neovim, Starship, Bash), see [../common/README.md](../common/README.md)

5. Restart your session or reload configurations.