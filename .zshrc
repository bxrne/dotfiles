
### General PATH Configuration
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/.bin:$HOME/.local/bin:$PATH"
export PATH="/Users/adambyrne/code/kubernetes/third_party/protoc:$PATH"
export PATH="/Users/adambyrne/code/kubernetes/third_party/etcd:$PATH"

### Oh My Zsh Setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="alanpeabody"
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  colored-man-pages
  history-substring-search
  command-not-found
  docker
)

source $ZSH/oh-my-zsh.sh

### Shell History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

### Go Environment
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOROOT/bin:$GOBIN:$PATH"

### Java Environment
export JAVA_HOME=$(/usr/libexec/java_home -v 23)
export PATH="/usr/local/opt/openjdk@23/bin:$PATH"
export CPPFLAGS="-I/usr/local/opt/openjdk@23/include"

### Docker CLI Completions
fpath=(/Users/adambyrne/.docker/completions $fpath)
autoload -Uz compinit
compinit -C  # use zcompdump cache to speed up

### k9s
export K9S_CONFIG_DIR=".config/k9s"

### Enhanced Terminal Experience
# Zoxide: smarter cd replacement
eval "$(zoxide init zsh)"

# Fastfetch system info
[[ -x "$(command -v nerdfetch)" ]] && nerdfetch
