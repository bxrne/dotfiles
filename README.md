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
# install pacman pkgs
sudo pacman -S --needed - < pacman.txt
# dump pacman 
sudo pacman -Qqe > pacman.txt

# install aur pkgs 
yay -S --needed - < aur.txt
# dump aur 
yay -Qqe > aur.txt
```
