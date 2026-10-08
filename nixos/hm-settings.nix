# Home-manager settings for the `bxrne` user.
#
# Anything you want to edit by hand lives as a plain file in the dotfiles repo
# (see the `home.file` section at the bottom) and is symlinked in, so changes
# take effect without a rebuild. Everything else is generated from this file.
{ config, lib, pkgs, ... }:

let
  cfg = config.home.file;

  # Your dotfiles repo. Hardcoded because `lib.getEnv "HOME"` would be /root
  # when this is evaluated under `sudo nixos-rebuild`.
  dotfiles = "/home/bxrne/dotfiles";
  fontName = "JetBrainsMono Nerd Font";

  # Gruvbox Dark palette. Keep these in sync with emacs/init.el.
  gruvbox = {
    bg0Hard = "#1d2021";
    bg0 = "#282828";
    bg0Soft = "#32302f";
    bg1 = "#3c3836";
    bg2 = "#504945";
    bg3 = "#665c54";
    fg = "#ebdbb2";
    fgDim = "#928374";
    bright = "#fbf1c7";

    red = "#fb4934";
    green = "#b8bb26";
    yellow = "#fabd2f";
    blue = "#83a598";
    purple = "#d3869b";
    aqua = "#8ec07c";
    orange = "#fe8019";
  };

  # foot wants RGB as bare hex (`282828`), fuzzel wants 8-digit RRGGBBAA
  # without `#`, waybar/CSS/emacs want `#rrggbb`. All the palette values above
  # are stored as `#rrggbb`; strip the `#` here rather than at every call site.
  hex = c: lib.removePrefix "#" c;
in
{
  ###########################################################################
  # Shell
  ###########################################################################

  programs.bash = {
    enable = true;
    enableCompletion = true;

    # Bash is your login shell (/etc/passwd), so home-manager writes ~/.bashrc,
    # which is what a new foot terminal actually reads.
    initExtra = ''
      export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

      export PATH="/home/bxrne/.bun/bin:$PATH"  
      if [[ $- == *i* ]]; then
        # Colors below are Gruvbox: green user, blue path.
        export PS1="\[\e[38;2;184;187;38m\]\u\[\e[0m\]:\[\e[38;2;131;165;152m\]\w\[\e[0m\]\$ "

        bind 'set completion-ignore-case on' 2>/dev/null || true
        # Alt+Enter opens a line above without leaving insert state
        bind '"\e[alt][\C-m" "\e[10D\e[10C\a"' 2>/dev/null || true
      fi

      export EDITOR=emacsclient
      export VISUAL="$EDITOR"
      export PAGER=less
      export LESS='-R -F -X -i -M'
      # bat follows the same gruvbox theme as everything else.
      export BAT_THEME="gruvbox-dark"

      eval "$(starship init bash)"
      fastfetch
    '';

    shellAliases = {
      # ls
      ll = "ls -lAh";
      la = "ls -A";
      lt = "ls -lAh --time-style=long-iso";

      # eza
      tree = "eza --tree --level=2 --icons";
      t = "eza --tree --level=3 --icons --git";

      # cat / preview
      catp = "bat --style=plain --paging=never";

      # fzf
      ff = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";

      # misc
      lg = "lazygit";
      ld = "lazydocker";
      reload = "source ~/.bashrc";
      path = "echo \$PATH | tr ':' '\\n'";
      pi = "nix run github:lukasl-dev/pi.nix --";
      opencode = "bunx opencode-ai --";
      psf = "ps aux | grep -v grep | grep -i";
      sys = "btop";
      ff2 = "fastfetch";

      # git
      gcm = "git commit -m";
      gcan = "git commit --amend --no-edit";
      glog = "git log --oneline --decorate --graph -20";

      # docker
      dc = "docker compose";
      dcu = "docker compose up -d";
      dcd = "docker compose down";
      dprune = "docker system prune -af";

      # kubernetes
      k = "kubectl";
      kctx = "kubectl config use-context";
      kp = "kubectl get pods";
    };
  };

  # Prompt

  programs.starship = {
    enable = true;
    settings = {
      # One line: `$line_break` was wrapping the prompt character onto a
      # second line, and `add_newline` was pushing the whole thing down with a
      # blank line above it.
      add_newline = false;
      format = "$directory$git_branch$git_status$jobs$nodejs$python$golang$cmd_duration$character";
      right_format = "$all";
      character = {
        # Lambda is where input starts.
        success_symbol = "[λ](bold #b8bb26)";
        error_symbol = "[λ](bold #fb4934)";
        vicmd_symbol = "[λ](bold #83a598)";
      };
      directory = {
        # Gruvbox blue path, red lock.
        style = "bold #83a598";
        read_only_style = "bold #fb4934";
        truncation_length = 3;
        # starship 1.25 has no `truncation_style` key -- it warns and suggests
        # `truncation_symbol`. To get "just the leaf folder" behaviour, use
        # `truncate_to_repo = false`-style options instead; plain truncation
        # with a symbol is what this version supports.
        truncation_symbol = "…/";
      };
      # Module colors, gruvbox tones matching quickshell/foot/fuzzel.
      git_branch.style = "bold #8ec07c";
      git_status.style = "bold #fabd2f";
      jobs.style = "bold #928374";
      nodejs.style = "bold #b8bb26";
      python.style = "bold #fabd2f";
      golang.style = "bold #83a598";
      cmd_duration.style = "bold #fe8019";
      # Bash PS1 is set in initExtra; skip the duplicate from starship.
      aws.disabled = true;
    };
  };

  programs.direnv.enable = true;
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.gpg.enable = true;

  # Git. Signing key is the nixbook GPG key (see keys/gpg-nixbook.pub).

  programs.git = {
    enable = true;

    signing = {
      format = "openpgp";
      signByDefault = true;
      # nixbook key. Public half is keys/gpg-nixbook.pub. Private key stays in ~/.gnupg.
      key = "AE6B2C9E3BCECCDB";
    };

    settings = {
      user = {
        name = "bxrne";
        email = "adamrbyrne@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "simple";
      push.autoSetupRemote = true;
      fetch.prune = true;
      rerere.enabled = true;
      merge.conflictstyle = "zdiff3";
      diff.colorMoved = "zebra";
      delta.syntax-theme = "gruvbox-dark";
      color.ui = "auto";

      core = {
        pager = lib.getExe pkgs.delta;
        # Global excludes come from the dotfiles repo, so one ignore file
        # covers git everywhere. Point straight at the repo file rather than
        # through home.file, whose .source is now a derivation.
        excludesFile = "${dotfiles}/.gitignore";
      };

      alias = {
        st = "status";
        glg = "log --oneline --graph --decorate --all -20";
        amend = "commit --amend --no-edit";
        undo = "reset --soft HEAD~1";
        rv = "restore";
        sw = "switch -c";
      };
    };
  };

  # Terminal (foot)

  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "${fontName}:size=12";
        dpi-aware = "no";
        # foot's terminfo output ships only `foot` and `foot-direct`, and
        # ncurses adds `foot`/`foot-direct`/`foot+base` -- there is no
        # `foot-extra` anywhere in TERMINFO_DIRS. Pointing TERM at it makes
        # every TUI app fail with "Terminal type ... is not defined"
        term = "foot";
        initial-color-theme = "dark";
        bold-text-in-bright = "no";
        word-delimiters = ",│`|:\"'()[]{}<>";
        selection-target = "clipboard";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      # Gruvbox Dark, mapped onto foot's regular0..7 / bright0..7 slots.
      # foot 1.27 splits this into colours-dark / colours-light, and wants
      # bare hex -- hence `hex`.
      colors-dark = {
        alpha = "1.0";
        foreground = hex gruvbox.fg;
        background = hex gruvbox.bg0;
        cursor = "${hex gruvbox.bg0} ${hex gruvbox.fg}";
        flash = hex gruvbox.bg2;

        regular0 = hex gruvbox.bg0;   # black
        regular1 = hex gruvbox.red;   # red
        regular2 = hex gruvbox.green; # green
        regular3 = hex gruvbox.yellow;# yellow
        regular4 = hex gruvbox.blue;  # blue
        regular5 = hex gruvbox.purple;# magenta
        regular6 = hex gruvbox.aqua;  # cyan
        regular7 = hex gruvbox.fg;    # white

        bright0 = hex gruvbox.bg3;
        bright1 = hex gruvbox.red;
        bright2 = hex gruvbox.green;
        bright3 = hex gruvbox.yellow;
        bright4 = hex gruvbox.blue;
        bright5 = hex gruvbox.purple;
        bright6 = hex gruvbox.aqua;
        bright7 = hex gruvbox.bright;

        selection-foreground = hex gruvbox.bg0;
        selection-background = hex gruvbox.fg;
        jump-labels = "${hex gruvbox.bg0} ${hex gruvbox.yellow}";
        scrollback-indicator = "${hex gruvbox.bg0} ${hex gruvbox.blue}";
        urls = hex gruvbox.yellow;
      };

      cursor = {
        style = "block";
        blink = "no";
        unfocused-style = "hollow";
      };

      scrollback = {
        lines = "10000";
        multiplier = "3.0";
        indicator-position = "relative";
      };

      # foot's [key-bindings] is action = "key list", not key = action.
      key-bindings = {
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
        scrollback-up-page = "Shift+Page_Up";
        scrollback-down-page = "Shift+Page_Down";
        scrollback-up-line = "Shift+Up";
        scrollback-down-line = "Shift+Down";
        search-start = "Control+Shift+r";
        spawn-terminal = "Control+Shift+n";
        font-increase = "Control+plus Control+equal";
        font-decrease = "Control+minus";
        font-reset = "Control+0";
        unicode-input = "Control+Shift+u";
      };
    };
  };

  ###########################################################################
  # Launcher (fuzzel, bound to Mod+Space)
  ###########################################################################

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "${fontName}:size=14";
        dpi-aware = "no";
        use-bold = "yes";

        # Actions (foot client / foot server) are separate desktop files.
        show-actions = "no";
        prompt = "   ";
        placeholder = "Search apps…";
        icon-theme = "default";
        icons-enabled = "yes";
        hide-before-typing = "no";
        match-mode = "fzf";
        sort-result = "yes";
        match-counter = "yes";
        delayed-filter-ms = "120";
        message-mode = "expand";

        # Layout is sized against the *logical* screen (1536x960 -- eDP-1 runs
        # at scale 2), so `width`/`line-height` are in logical pixels even
        # though they end up at 2x on the panel.
        anchor = "center";
        x-margin = 60;
        y-margin = 60;
        lines = 15;
        width = 64;
        tabs = 4;
        horizontal-pad = 28;
        vertical-pad = 24;
        inner-pad = 18;
        line-height = 34;
        letter-spacing = 0;

        layer = "overlay";
        keyboard-focus = "exclusive";
        exit-on-keyboard-focus-loss = "yes";
        enable-mouse = "yes";
      };

      # Square corners, as requested. The border stays for definition.
      border = {
        width = 2;
        radius = 0;
      };

      # [colors] -- flat keys, 8-digit RRGGBBAA with no `#`, hence `hex`.
      colors = {
        background = hex gruvbox.bg0 + "ff";
        text = hex gruvbox.fg + "ff";
        message = hex gruvbox.fgDim + "ff";
        prompt = hex gruvbox.aqua + "ff";
        placeholder = hex gruvbox.bg3 + "ff";
        input = hex gruvbox.fg + "ff";
        match = hex gruvbox.aqua + "ff";
        selection = hex gruvbox.bg0Soft + "ff";
        selection-text = hex gruvbox.fg + "ff";
        selection-match = hex gruvbox.blue + "ff";
        counter = hex gruvbox.bg3 + "ff";
        border = hex gruvbox.bg2 + "ff";
      };
    };
  };

  # pkgs.neovim ships nvim.desktop as "Neovim wrapper" (Terminal=true).
  # Fuzzel lists every system .desktop file, and this one fails to launch
  # unless a terminal is configured. Hide it; nvim is a terminal command.
  xdg.desktopEntries.nvim = {
    name = "Neovim wrapper";
    noDisplay = true;
    exec = "nvim";
    terminal = true;
  };

  ###########################################################################
  # Status bar (waybar)
  ###########################################################################


  ###########################################################################
  # Lock screen (swaylock)
  ###########################################################################

  programs.swaylock = {
    enable = true;
    settings = {
      font = fontName;
      font-size = 18;
      show-failed-attempts = true;
      ignore-empty-password = true;
      indicator-idle-visible = false;
      indicator-caps-lock = true;
      clock = false;

      # Fallback if the image cannot be loaded. Image is the lock screen background.
      color = "3c3c3c";
      image = "/home/bxrne/Wallpapers/wallpaper.png";
      scaling = "fill";

      indicator-radius = 120;
      indicator-thickness = 16;

      # The ring around the indicator, by input state.
      inside-color = hex gruvbox.bg1;
      inside-ver-color = hex gruvbox.bg1;
      inside-wrong-color = hex gruvbox.bg1;
      inside-clear-color = hex gruvbox.bg1;
      inside-caps-lock-color = hex gruvbox.bg1;

      ring-color = hex gruvbox.bg2;
      ring-ver-color = hex gruvbox.blue;
      ring-wrong-color = hex gruvbox.red;
      ring-clear-color = hex gruvbox.green;
      ring-caps-lock-color = hex gruvbox.yellow;

      key-hl-color = hex gruvbox.aqua;
      bs-hl-color = hex gruvbox.orange;
      separator-color = "00000000";

      text-color = hex gruvbox.fg;
      text-ver-color = hex gruvbox.fg;
      text-wrong-color = hex gruvbox.red;
      text-clear-color = hex gruvbox.green;
      text-caps-lock-color = hex gruvbox.yellow;

      line-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-uses-inside = true;
    };
  };


  # Tooling

  home.packages = with pkgs; [
    # NOTE: the JetBrainsMono Nerd Font itself is installed system-wide in
    # nixos/configuration.nix, so the greeter and fontconfig see it too.

    # CLI tooling
    bat
    ripgrep
    fd
    fzf
    jq
    delta
    eza
    tokei
    lazygit
    lazydocker
    nerdctl
    fff
    swaybg
    quickshell
  ];

  # Files from dotfiles repo

  # Live symlinks into the repo, not store copies: edit the file in dotfiles
  # and it takes effect immediately, no rebuild. (Plain string sources get
  # *copied* into the nix store, which silently makes every edit require a
  # rebuild -- mkOutOfStoreSymlink is what avoids that.)
  home.file = {
    ".gitignore".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.gitignore";
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.tmux.conf";
  };

  xdg.configFile = {
    "nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nvim/init.lua";
    "clangd/config.yaml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/clangd/config.yaml";
    "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/niri/config.kdl";
    "quickshell".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/quickshell";
    "fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/fastfetch/config.jsonc";
  };

  # GitHub SSH for this machine. Private key is ~/.ssh/id_ed25519 (created by gh auth).
  # Public copies: keys/id_ed25519.pub and keys/gpg-nixbook.pub. Do not commit private keys.
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };

  # Wallpaper is a static image via swaybg, spawned from niri config.kdl.
  # spawn-at-startup only runs when niri itself starts, not on config reload.
  # After editing that line: niri msg action quit, then log back in.
  # Or, for the current session: swaybg -m fill -i ~/Wallpapers/wallpaper.png
}
