# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="agnoster"
# ZSH_THEME="spaceship"
# ZSH_THEME=powerlevel10k/powerlevel10k
eval "$(starship init zsh)"

# Set the default user (removes the user@hostname part of the regular prompt)
DEFAULT_USER="simonbein"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.

# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Since we source kubectl with asdf we need to source it before
# running the kubectl plugin
source $HOME/.asdf/asdf.sh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  docker
  gitfast
  git-open
  terraform
  colored-man-pages
  copydir
  dircycle
  tmux
  osx
  zsh-z
  kubectl
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Alias NeoVim as Vim
alias vim=nvim

# Enable Syntax highlighting
[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Fix color for autocomplete in tmux
export TERM=xterm-256color

# Enable the kube-ps1 (https://github.com/jonmosco/kube-ps1) extension
# [ -f /usr/local/opt/kube-ps1/share/kube-ps1.sh ] && source /usr/local/opt/kube-ps1/share/kube-ps1.sh && \
# PROMPT='$(kube_ps1)'$PROMPT&& \
# KUBE_PS1_SYMBOL_ENABLE="false" && \
# KUBE_PS1_NS_COLOR="green" && \
# KUBE_PS1_CTX_COLOR="blue"

# Set up gs as alias for 'git status'
alias gs='git status'

# Kubernetes Aliases
alias kc='kubectl'
alias kcd='kubectl describe'
alias kcl='kubectl logs'
alias kcg='kubectl get'
alias wkc='watch kubectl'
alias dkc='kubectl --context ambid-dev-app-admin'
alias skc='kubectl --context ambid-stg-app-admin'

# sed alias to use gsed
alias sed='gsed' 

# Change `kubectl edit` editor to vim
export KUBE_EDITOR='vim'

# Aliases for kubectx and kubens
alias kns='kubens'
alias kctx='kubectx'

[[ -s "/Users/simonbein/.gvm/scripts/gvm" ]] && source "/Users/simonbein/.gvm/scripts/gvm"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/simonbein/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/simonbein/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/simonbein/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/simonbein/google-cloud-sdk/completion.zsh.inc'; fi

# Kubebuilder
export PATH=$PATH:/usr/local/kubebuilder/bin

# iTerm shell integration (https://www.iterm2.com/documentation-shell-integration.html)
source ~/.iterm2_shell_integration.zsh
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -s "/Users/simonbein/.scm_breeze/scm_breeze.sh" ] && source "/Users/simonbein/.scm_breeze/scm_breeze.sh"

# Stern autocompletion
source <(stern --completion=zsh)

# Azure CLI autocomplete
[ -s "/usr/local/etc/bash_completion.d/az" ] && source "/usr/local/etc/bash_completion.d/az"

# Exa alias
alias ls='exa'
alias exa='exa --long --git'

# Bat alias
alias cat='bat'
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault

# Other Alias
alias cl='clear'
alias tf='terraform'
alias dc='docker-compose'
alias sp='spotify'
alias fk='fly -t k'
alias cdg='cd $(git rev-parse --show-cdup)'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

FZF_COMPLETION_TRIGGER='*'

_fzf_complete_pass() {
  _fzf_complete '+m' "$@" < <(
    pwdir=${PASSWORD_STORE_DIR-~/.password-store/}
    stringsize="${#pwdir}"
    find "$pwdir" -name "*.gpg" -print |
        cut -c "$((stringsize + 1))"-  |
        sed -e 's/\(.*\)\.gpg/\1/'
  )
}

# krew custom path aliasing
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/simonbein/.sdkman"
[[ -s "/Users/simonbein/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/simonbein/.sdkman/bin/sdkman-init.sh"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
