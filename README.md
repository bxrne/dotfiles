# dotfiles

NixOS and home-manager config for `nixbook` (Apple T2, Gruvbox Dark).
`/etc/nixos/configuration.nix` points at this repo. Apply with:

```sh
sudo nixos-rebuild switch
```

Logout and back in after the first activation, or after anything niri only
reads at session start (startup spawns, greetd). A running compositor does
not re-run `spawn-at-startup` on config reload.

## Layout

```
dotfiles/
├── .config/niri/config.kdl       # compositor, binds, startup spawns
├── .config/nvim/init.lua         # neovim (vim.pack)
├── .config/quickshell/           # launcher, control centre, notifications
├── .config/clangd/config.yaml
├── .tmux.conf
├── .gitignore                    # also the global git excludes file
├── keys/                         # public keys only
├── scripts/github-keys.sh
└── nixos/
    ├── configuration.nix         # boot, greetd, system packages, PAM
    ├── home.nix                  # home-manager pin + user import
    ├── hm-settings.nix           # user programs and generated configs
    └── hardware-configuration.nix  # generated, gitignored
```

## Live files vs generated configs

| Kind | Where | Rebuild? |
|---|---|---|
| Hand-edited | repo files symlinked with `mkOutOfStoreSymlink` | No |
| Generated | `programs.*` in `nixos/hm-settings.nix` | Yes |

Live symlinks: `.gitignore`, `.tmux.conf`, `nvim/init.lua`, `clangd/config.yaml`,
`niri/config.kdl`, `quickshell/`. A plain string `source` is copied into the
Nix store and will not pick up edits. Commit from this repo, not from `~/.config`.

Generated today: bash, starship, git, ssh, gpg, foot, fuzzel, swaylock.
`fuzzel` is installed and themed, but the bound launcher is quickshell.

## Desktop

greetd (`tuigreet`) starts `niri-session`. Font is JetBrainsMono Nerd Font,
installed system-wide so fontconfig and the greeter can see it.

| Key | Action |
|---|---|
| `Mod+Return` | foot |
| `Mod+b` | chromium |
| `Mod+Space` | quickshell launcher |
| `Mod+Backspace` | quickshell control centre |
| `Super+Alt+L` | swaylock |
| `Mod+Shift+/` | hotkey overlay |

`Mod` is Super on the TTY. Focus follows the mouse. Wallpaper is
`~/Wallpapers/wallpaper.png` (not in git), started by niri:

```kdl
spawn-at-startup "/home/bxrne/.nix-profile/bin/swaybg" "-m" "fill" "-i" "/home/bxrne/Wallpapers/wallpaper.png"
```

`~` is not expanded there. For the current session without a relogin:

```sh
swaybg -m fill -i ~/Wallpapers/wallpaper.png
```

swaylock uses that same image (`scaling = fill`) once home-manager has
rewritten `~/.config/swaylock/config`. PAM is enabled in `configuration.nix`.

## Shell and git

Bash aliases and the starship prompt come from `hm-settings.nix`. Notable
aliases: `ll`, `t` / `tree` (eza), `catp`, `ff`, `lg`, `gcm`, `glog`, `dc`,
`sys`, `pi`.

Git signs commits by default with `AE6B2C9E3BCECCDB` (`adamrbyrne@gmail.com`).
Public halves live in `keys/`. Private keys stay in `~/.ssh` and `~/.gnupg`.
Refresh and upload GPG with `scripts/github-keys.sh`, then:

```sh
gh auth refresh -h github.com -s write:gpg_key
gh gpg-key add keys/gpg-nixbook.pub
```

`programs.bash` still exports `EDITOR=emacsclient`. Emacs is not installed;
the editor config in this repo is neovim.

## Adding config

Hand-edited file:

```nix
xdg.configFile."foo/config".source =
  config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/foo/config";
```

Generated program: add a `programs.<name>` block, then rebuild.
Check niri before relying on a reload: `niri validate`.

Do not commit `nixos/hardware-configuration.nix`, `*.key` / `*.pem` / `*.gpg`,
`secrets/`, or `.grok/` (API keys).
