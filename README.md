# dotfiles

Arch linux config

## Cfgs
```bash
# .configs 
stow -t ~/.config config

# ~/'s
stow -t ~/ home

# etc/'s
sudo stow -t /etc etc

# scripts (conv commits, tmux sessions)
stow -t ~/scripts scripts
```

## Pkgs

```bash
sudo pacman -S --needed - < pacman.txt # install pacman pkgs
sudo pacman -Qqe > pacman.txt # dump pacman pkgs

yay -S --needed - < aur.txt # install aur pkgs
yay -Qqm > aur.txt # dump aur pkgs
```
