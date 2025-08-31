# macOS Setup

This folder contains configurations for macOS specific tools: Hammerspoon, Zellij, Ghostty, Sketchybar etc.

## Prerequisites

- macOS installed
- Brew 
- Lua

## Installation

1. Switch to the macos branch for the full macOS configurations:
   ```bash
   git checkout macos
   ```

2. Install required packages via Homebrew:
   ```bash
   brew install hammerspoon zellij ghostty neovim starship sketchybar
   ```

3. Create symbolic links (after checking out macos branch):
   ```bash
   ln -s ~/dotfiles/macos/hammerspoon ~/.hammerspoon
   ln -s ~/dotfiles/macos/zellij ~/.config/zellij
   ln -s ~/dotfiles/macos/ghostty ~/.config/ghostty
   ln -s ~/dotfiles/macos/sketchybar ~/.config/sketchybar

   # For common configs: nvim, starship, etc.
   ln -s ~/dotfiles/common/nvim ~/.config/nvim
   ln -s ~/dotfiles/common/starship.toml ~/.config/starship.toml
   ln -s ~/dotfiles/common/.bashrc ~/.bashrc
   ```

4. For common configurations, see [../common/README.md](../common/README.md)

5. Restart your session or reload configurations.
