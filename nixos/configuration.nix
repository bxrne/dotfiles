{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./home.nix
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/apple/t2"
    ];

  # EFI boot
  boot.loader.systemd-boot.enable = false; # NEEDS VARS BUT T2 NO BUENO
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Boot loader
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # System settings
  networking.hostName = "nixbook";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # T2 hardware
  nixpkgs.config.allowUnfree = true;
  hardware.apple-t2.firmware.enable = true;
  hardware.apple-t2.firmware.version = "sonoma";

  users.users.bxrne = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    packages = with pkgs; [
        tree
        git
    ];
  };

  # Docker (socket starts on boot)
  virtualisation.docker.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
  ];

  environment.systemPackages = with pkgs; [
      foot
      neovim
      nerd-fonts.jetbrains-mono
      fuzzel
      brightnessctl
      playerctl
      grim
      slurp
      wl-clipboard
      bluetui
      wl-mirror
      wf-recorder
      bun
      go
      gopls
      golangci-lint
      cargo
      zig
      zls
      stow
      gcc
      clang-tools # clangd + clang-tidy; builds stay on gcc/g++
      cmake
      bazel
      python3
      pyright
      # Language servers for the nvim config (nixos/hm-settings pins none of
      # these elsewhere; nvim enables each one only if its binary is on PATH)
      lua-language-server
      typescript-language-server
      vscode-json-languageserver
      vscode-langservers-extracted # eslint language server
      bash-language-server
      nil
      just
      just-lsp
      rust-analyzer
      rustc # sysroot for rust-analyzer's proc-macro expansion
      btop
      starship
      eza
      lazygit
      lazydocker
      docker
      docker-compose
      tmux
      fastfetch
      fzf
      chromium
      gh
  ];


  programs.niri.enable = true;

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" ];
    sansSerif = [ "JetBrainsMono Nerd Font" ];
  };

  security.pam.services.swaylock = { };

  services.openssh.enable = true;
  services.greetd = {
  enable = true;
  settings =  {
    default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
    };
  };
  };

  system.stateVersion = "26.11"; # Did you read the comment?
}
