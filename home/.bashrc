# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias ls='ls --color=auto'
alias lg='lazygit'
alias grep='grep --color=auto'
alias cd='z'

# scripts
alias cm='~/scripts/cm/cm.sh'
alias tmuxy='~/scripts/tmuxy/tmuxy.sh'
export GUM_INPUT_CURSOR_FOREGROUND="#f59e0b"
export GUM_INPUT_PROMPT_FOREGROUND="#8a8a8d"
export GUM_INPUT_PROMPT="* "
export GUM_INPUT_WIDTH=80

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

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
test -r '/home/bxrne/.opam/opam-init/init.sh' && . '/home/bxrne/.opam/opam-init/init.sh' > /dev/null 2> /dev/null || true

# start podman socket if not running
if ! pgrep -u "$USER" -f "podman system service" > /dev/null; then
    systemctl --user start podman.socket
fi

# set docker host to podman socket
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock

# set editor to neovim
export EDITOR='nvim'

tmuxy
