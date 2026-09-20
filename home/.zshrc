export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"

# Auto-attach to the most recently used tmux session, or start one
if [[ -z "$TMUX" && -o interactive ]] && command -v tmux &> /dev/null; then
  last_session=$(tmux list-sessions -F '#{session_last_attached} #{session_name}' 2>/dev/null | sort -rn | head -n1 | cut -d' ' -f2-)
  if [ -n "$last_session" ]; then
    exec tmux attach-session -t "$last_session"
  else
    exec tmux new-session
  fi
fi

if [ -s "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

export NVM_DIR="$HOME/.nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi

if [ -s "$NVM_DIR/bash_completion" ]; then
  . "$NVM_DIR/bash_completion"
fi



export EDITOR="nvim"
export VISUAL="nvim"



export LANG=C.utf8
unset LC_ALL




HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY



autoload -Uz compinit
compinit -i

if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null

  if [ -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null
  fi
fi



alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."



if command -v eza &> /dev/null; then
  alias ls="eza --icons=always --group-directories-first"
  alias ll="eza -lh --icons=always --group-directories-first --git"
  alias la="eza -lah --icons=always --group-directories-first --git"
  alias lt="eza --tree --level=2 --icons=always"
  alias lta="eza --tree --level=2 -a --icons=always"
elif command -v exa &> /dev/null; then
  alias ls="exa --icons --group-directories-first"
  alias ll="exa -lh --icons --group-directories-first --git"
  alias la="exa -lah --icons --group-directories-first --git"
  alias lt="exa --tree --level=2 --icons"
  alias lta="exa --tree --level=2 -a --icons"
else
  alias ls="ls --color=auto"
  alias ll="ls -la"
  alias la="ls -a"
fi

alias grep="grep --color=auto"

alias g="git"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"
alias gc="git commit"
alias gca="git commit -a"

alias vim="nvim"
alias vi="nvim"
alias n="nvim"

alias lg="lazygit"
alias ld="lazydocker"

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi
export PATH="/home/adamr/.terragrunt/bin:$PATH"

# Added by the Hunk installer (https://hunk.dev)
export PATH='/home/adamr/.hunk/bin':"$PATH"
