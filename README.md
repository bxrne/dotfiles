# dotfiles

macOS config, packages managed with nix.

## Cfgs
```bash
# .configs
stow -t ~/.config config

# ~/'s
stow -t ~/ home
```

## Pkgs

Packages live in the active nix profile (`$HOME/.nix-profile`). The
registry maps the `nixpkgs` flake to `nixpkgs-26.05-darwin`.

```bash
nix profile add 'nixpkgs#<pkg>' # install a package
nix profile list                # list installed packages
nix profile remove <name>       # remove a package by name
nix-collect-garbage -d          # clean the nix store
```