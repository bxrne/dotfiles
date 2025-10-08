# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias cd='z'
eval "$(starship init bash)"
eval "$(zoxide init bash)"

export PATH="$HOME/.local/bin:$PATH"
export PATH=/home/bxrne/.opencode/bin:$PATH
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

rxfetch

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH="$PATH:$HOME/.dotnet/tools"

# pnpm
export PNPM_HOME="/home/bxrne/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
