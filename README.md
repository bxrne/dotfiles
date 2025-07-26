# dotfiles

My collective configuration for tools.

## Tools Configured

- **nvim**: Neovim configuration
- **zsh**: Z shell configuration
- **zellij**: Terminal workspace manager configuration

## Setting Up on Unix/Linux

To use these configurations, you can create symbolic links from the configuration files in this repository to your `~/.config` directory. Here's how you can do it:

1. Clone this repository to your home directory or any preferred location:
   ```bash
   git clone https://github.com/bxrne/dotfiles.git ~/dotfiles
   ```

2. Create symbolic links for each tool:

   ```bash
   ln -s ~/dotfiles/nvim ~/.config/nvim
   ln -s ~/dotfiles/.zshrc ~/.zshrc
   ln -s ~/dotfiles/zellij ~/.config/zellij
   ```

3. Restart your terminal or reload the configurations for the changes to take effect.

## Setting Up on Windows

For Windows, you can use symbolic links as well, but the process is slightly different. Here's how you can do it:

1. Clone this repository to your preferred location, e.g., `C:\Users\YourUsername\dotfiles`.

2. Open a Command Prompt or PowerShell with Administrator privileges.

3. Create symbolic links for each tool:
   ```powershell
   mklink /D %USERPROFILE%\.config\nvim C:\Users\YourUsername\dotfiles\nvim
   mklink /D %USERPROFILE%\.zshrc C:\Users\YourUsername\dotfiles\.zshrc
   mklink /D %USERPROFILE%\.config\zellij C:\Users\YourUsername\dotfiles\zellij
   ```

4. Restart your terminal or reload the configurations for the changes to take effect.

## Notes

- Ensure that the `~/.config` directory exists on Unix/Linux or `%USERPROFILE%\.config` exists on Windows before creating the symbolic links.
- If you encounter any issues, double-check the paths and permissions.


