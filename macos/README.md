# macOS Setup

This folder contains configurations for macOS specific tools: Hammerspoon, Zellij, Ghostty, etc.

## Prerequisites

- macOS installed

## Installation

1. Switch to the macos branch for the full macOS configurations:
   ```bash
   git checkout macos
   ```

2. Install required packages via Homebrew:
   ```bash
   brew install hammerspoon zellij ghostty neovim starship
   ```

3. Create symbolic links (after checking out macos branch):
   ```bash
   ln -s ~/dotfiles/.zshrc ~/.zshrc
   ln -s ~/dotfiles/hammerspoon ~/.hammerspoon
   ln -s ~/dotfiles/zellij ~/.config/zellij
   ln -s ~/dotfiles/ghostty ~/.config/ghostty
   # For common configs: nvim, starship, etc.
   ln -s ~/dotfiles/common/nvim ~/.config/nvim
   ln -s ~/dotfiles/common/starship.toml ~/.config/starship.toml
   ```

4. For common configurations, see [../common/README.md](../common/README.md)

5. Restart your session or reload configurations.