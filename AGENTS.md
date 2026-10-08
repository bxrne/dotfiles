# Agent notes

Personal NixOS dotfiles for `nixbook` (Apple T2). Read `README.md` first.
Change the smallest file that actually owns the setting. Do not refactor
unrelated Nix, and do not commit secrets.

## Where to edit

- System (boot, greetd, PAM, `environment.systemPackages`, niri module):
  `nixos/configuration.nix`.
- home-manager pin and backup behaviour: `nixos/home.nix`.
  Pin is the tarball `df4e0465717a2d34f05b8ccd967275aaf3ceaa01`. `useGlobalPkgs = true`.
- User programs and generated configs: `nixos/hm-settings.nix`.
- Live configs: the repo paths symlinked in `home.file` / `xdg.configFile`.
  Always use `config.lib.file.mkOutOfStoreSymlink`. A string source is a store
  copy and edits will look like they did nothing.
- `~/.config/...` is often that symlink. Edit the repo path or the symlink;
  they are the same file. Do not replace the symlink with a regular file.

`nixos/hardware-configuration.nix` is machine-generated and gitignored.
`/etc/nixos/configuration.nix` is a symlink into this repo.

## Desktop facts that are easy to get wrong

- Compositor is niri. Launcher and control centre are quickshell (`qs`), not
  fuzzel. fuzzel is still generated; do not bind `Mod+Space` back to it unless
  asked. waybar is not configured.
- Terminal is foot. Browser bind is chromium. Lock is swaylock.
- Wallpaper path is `/home/bxrne/Wallpapers/wallpaper.png`. niri starts
  `swaybg` via `spawn-at-startup` in `.config/niri/config.kdl`. That runs only
  when niri starts, not on `niri msg action load-config-file`. `~` is not
  expanded. Use the nix-profile path to `swaybg`, not a bare name, if PATH at
  session start is in doubt.
- swaylock's image and colours are generated. Changing `programs.swaylock` does
  nothing until `sudo nixos-rebuild switch`. Do not hand-edit the store symlink
  at `~/.config/swaylock/config`.
- Gruvbox lives in the `gruvbox` attrset in `hm-settings.nix` and again in
  `.config/quickshell/shell.qml`. Keep those in sync when changing palette.
  Formats differ: `#rrggbb` (niri, quickshell), bare `rrggbb` (foot, swaylock),
  8-digit `rrggbbaa` (fuzzel). Use the `hex` helper.
- Neovim is `.config/nvim/init.lua` (`vim.pack`). `EDITOR` in bash is still
  `emacsclient`; emacs is not installed. Do not "fix" that unless asked.
- T2 boot: GRUB, `efiInstallAsRemovable`, `canTouchEfiVariables = false`.
  Do not switch the bootloader to systemd-boot.

## Apply and validate

Do not run `sudo nixos-rebuild switch` unless the user asks. It is slow and
needs root. When they do, it is the only apply path; this is not a standalone
home-manager flake.

After niri edits: `niri validate`. After a Nix edit, say what needs a rebuild
versus what is live. Startup spawns need a niri restart (`niri msg action quit`
drops the session).

## Git

No history yet, or history may be local-only. Do not push unless asked.
Signing is on (`AE6B2C9E3BCECCDB`); do not pass `--no-gpg-sign` unless asked.
Do not skip hooks.

Never commit:

- private keys, `secrets/`, `*.key`, `*.pem`, `*.gpg`
- `.grok/` (contains an API key)
- `nixos/hardware-configuration.nix`
- `~/Wallpapers`

Public keys in `keys/` are intentional. `scripts/github-keys.sh` only copies
public material into the repo.

## Style

Match the surrounding Nix comments: short, why-not-what. Do not add new
packages, binds, or services that were not requested. Prefer editing an
existing module over a new file.
