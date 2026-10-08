# Home Manager config (pinned revision; bump w/ nixpkgs)
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # `home-manager` is already a NixOS module here, so importing it is enough.
  imports = [
    (import "${builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/df4e0465717a2d34f05b8ccd967275aaf3ceaa01.tar.gz";
    }}/nixos")
  ];

  home-manager = {
    useGlobalPkgs = true;

    # If home-manager wants to symlink a file that already exists (e.g. your
    # current ~/.bashrc), activation would abort with "would be clobbered".
    # With this set, the existing file is moved aside to `<name>.hm-old`
    # instead, and activation proceeds.
    backupFileExtension = "hm-old";

    users.bxrne = {
      home.homeDirectory = "/home/bxrne";
      home.stateVersion = "26.11";

      # Provides the `home-manager` CLI inside the user profile.
      programs.home-manager.enable = true;

      imports = [ ./hm-settings.nix ];
    };
  };

  # Fonts have to go through `fonts.packages`, not `environment.systemPackages`
  # -- otherwise fontconfig never sees them and foot/fuzzel/waybar silently
  # fall back to DejaVu Sans. Declared here (a NixOS option, at the module's
  # top level) so no sudo edit of configuration.nix is needed.
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" ];
    sansSerif = [ "JetBrainsMono Nerd Font" ];
  };
}