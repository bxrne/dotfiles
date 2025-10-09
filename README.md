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

```

## Pkgs

```bash
sudo pacman -S --needed - < pacman.txt
yay -S --needed - < aur.txt
```
