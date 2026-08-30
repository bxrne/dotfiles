export PATH="$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH"

# Prefer rustup-managed Rust (rustc, cargo, rust-analyzer) over any Nix copy.
# Sourced after PATH export so $HOME/.cargo/bin wins.
if [ -s "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

export EDITOR="zed"
export VISUAL="zed"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export COLORTERM="truecolor"
export TERM="xterm-256color"
export PODMAN_COMPOSE_WARNING_LOGS=false
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS    # Delete old duplicate entries in history
setopt HIST_REDUCE_BLANKS      # Remove redundant blanks
setopt SHARE_HISTORY           # Share history across all terminal instances
setopt INC_APPEND_HISTORY      # Write to history file immediately

autoload -Uz compinit && compinit -i

if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
  if [ -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519" 2>/dev/null
  fi
fi

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi


alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias docker=podman

eval "$(zoxide init zsh)"
export DOCKER_HOST="unix:///var/folders/zh/mtxmqnfs5yn2vkj4t4r_qhyr0000gn/T/podman/podman-machine-default-api.sock"

if command -v eza &> /dev/null; then
  alias ls="eza --icons=auto --group-directories-first"
  alias ll="eza -lh --icons=auto --group-directories-first --git"
  alias la="eza -lah --icons=auto --group-directories-first --git"
  alias lt="eza --tree --level=2 --icons=auto"
  alias lta="eza --tree --level=2 -a --icons=auto"
else
  alias ls="ls -G"
  alias ll="ls -laG"
  alias la="ls -aG"
fi

alias grep="grep --color=auto"

alias docker="podman"

alias g="git"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"
alias gc="git commit"
alias gca="git commit -a"

alias nix-clean="nix-collect-garbage -d"

if command -v pfetch &> /dev/null; then
  pfetch
fi

if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi
