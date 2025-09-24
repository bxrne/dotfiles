# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias lg='lazygit'
alias grep='grep --color=auto'
alias cd='z'
alias podstop='podman ps -q | xargs podman stop'
alias kindstop='podman ps -q --filter "label=io.x-k8s.kind.cluster" | xargs podman pause'
alias ptail='
  FILE=$(fzf --preview "bat --style=numbers --color=always --line-range :200 {}" --height=40% --reverse --border) &&
  clear &&
  echo "Following: $FILE" &&
  tail -n 50 -f "$FILE" | bat --paging=never --color=always -l log
'
alias diff='critique'

# enhanced commands
alias ls='exa --icons --group-directories-first --color=auto'
alias ll='exa -la --icons --group-directories-first --color=auto'
alias la='exa -a --icons --group-directories-first --color=auto'
alias rg='rg --color=auto'
alias cat='bat --paging=never --color=auto'
alias tree='exa --tree --icons --group-directories-first --color=auto'
alias grep='grep --color=auto -i'

# mobile-friendly aliases
alias q='exit'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# enable 
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(ssh-agent -s)" >> /dev/null  

# Exports
export PATH="$HOME/.local/bin:$PATH"
export PATH=/home/bxrne/.opencode/bin:$PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PNPM_HOME="/home/bxrne/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
export KIND_EXPERIMENTAL_PROVIDER=podman
export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always {}' --preview-window=right:60%:wrap"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
test -r '/home/bxrne/.opam/opam-init/init.sh' && . '/home/bxrne/.opam/opam-init/init.sh' > /dev/null 2> /dev/null || true
export PATH="$HOME/.platformio/penv/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
export TERM=xterm-256color
export KUBE_EDITOR='nvim'
export EDITOR='nvim'
export OPENCODE_DISABLE_MODELS_FETCH=true
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH=$PATH:$HOME/go/bin

# Autostarts
if command -v podman > /dev/null && systemctl --user is-active --quiet podman.socket; then
    if ! pgrep -u "$USER" -f "podman system service" > /dev/null; then
        systemctl --user start podman.socket
    fi
fi


fastfetch

export PATH="$HOME/.zigup:$HOME/.zig:$PATH"
