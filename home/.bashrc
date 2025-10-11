# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias ls='ls --color=auto'
alias lg='lazygit'
alias grep='grep --color=auto'
alias cd='z'

# enable 
eval "$(starship init bash)"
eval "$(zoxide init bash)"

# export paths 
export PATH="$HOME/.local/bin:$PATH"
export PATH=/home/bxrne/.opencode/bin:$PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PNPM_HOME="/home/bxrne/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# start podman socket if not running
if ! pgrep -u "$USER" -f "podman system service" > /dev/null; then
    systemctl --user start podman.socket
fi

# set docker host to podman socket
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock

# set editor to neovim
export EDITOR='nvim'
rxfetch
