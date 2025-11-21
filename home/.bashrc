# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias lg='lazygit'
alias grep='grep --color=auto'
alias cd='z'
alias ptail='
  FILE=$(fzf --preview "bat --style=numbers --color=always --line-range :200 {}" --height=40% --reverse --border) &&
  clear &&
  echo "Following: $FILE" &&
  tail -n 50 -f "$FILE" | bat --paging=never --color=always -l log
'

alias diff='critique'

# scripts
alias cm='~/scripts/cm/cm.sh'
alias zellijy='~/scripts/zellijy/zellijy.sh'

# enhanced commands
alias ls='exa --icons --group-directories-first --color=auto'
alias ll='exa -la --icons --group-directories-first --color=auto'
alias la='exa -a --icons --group-directories-first --color=auto'
alias rg='rg --color=auto'
alias cat='bat --paging=never --color=auto'
alias tree='exa --tree --icons --group-directories-first --color=auto'

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
export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always {}' --preview-window=right:60%:wrap"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
test -r '/home/bxrne/.opam/opam-init/init.sh' && . '/home/bxrne/.opam/opam-init/init.sh' > /dev/null 2> /dev/null || true
export PATH="$HOME/.platformio/penv/bin:$PATH"
export ZELLIJ_THEME="gruvbox-dark"
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
export EDITOR='nvim'

# Autostarts
if ! pgrep -u "$USER" -f "podman system service" > /dev/null; then
    systemctl --user start podman.socket
fi

if [ -z "$ZELLIJ" ] && [ -z "$ZELLIJ_AUTO_ATTACH" ]; then
    zellij setup --dump-config > /dev/null 2>&1 || true
    zellij options --theme $ZELLIJ_THEME
fi
