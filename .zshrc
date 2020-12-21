# Source nix
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then source $HOME/.nix-profile/etc/profile.d/nix.sh; fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Temporarily set locale, to solve https://discourse.brew.sh/t/failed-to-set-locale-category-lc-numeric-to-en-ru/5092/24
# Until I have time to find a more permanent solution
export LANG=en_US.UTF-8

# Load the starship theme
eval "$(starship init zsh)"

# Set the default user (removes the user@hostname part of the regular prompt)
DEFAULT_USER="simonbein"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
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

# Alias NeoVim as Vim
alias vim=nvim
export EDITOR='nvim'

# Fix color for autocomplete in tmux
export TERM=xterm-256color

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
alias kcwn='kc get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,NODE:.spec.nodeName'

# Change `kubectl edit` editor to vim
export KUBE_EDITOR='nvim'

# Aliases for kubie
alias kns='kubie ns'
alias kctx='kubie ctx'

# iTerm shell integration (https://www.iterm2.com/documentation-shell-integration.html)
source ~/.iterm2_shell_integration.zsh

[ -s "/Users/simonbein/.scm_breeze/scm_breeze.sh" ] && source "/Users/simonbein/.scm_breeze/scm_breeze.sh"

# Stern autocompletion
source <(stern --completion=zsh)

# Azure CLI autocomplete
[ -s "/usr/local/etc/bash_completion.d/az" ] && source "/usr/local/etc/bash_completion.d/az"

# Exa alias
alias ls='exa'
alias exa='exa --long --git'

# Bat alias
alias cat='bat --theme "TwoDark"'
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault

# Other Alias
alias cl='clear'
alias tf='terraform'
alias dc='docker-compose'
alias sp='spotify'
alias fk='fly -t k'
alias cdg='cd $(git rev-parse --show-cdup)'
alias pass='gopass'

if [ -n "${commands[fzf-share]}" ]; then
  FZF_COMPLETION_TRIGGER='*'
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

# Source syntax highlighting plugin
source $(nix-env -q --out-path --no-name zsh-syntax-highlighting)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Completions

_fzf_complete_pass() {
  _fzf_complete '+m' "$@" < <(
    pwdir=${PASSWORD_STORE_DIR-~/.password-store/}
    stringsize="${#pwdir}"
    find "$pwdir" -name "*.gpg" -print |
        cut -c "$((stringsize + 1))"-  |
        sed -e 's/\(.*\)\.gpg/\1/'
  )
}

# Gopass
source <(gopass completion bash)

# krew custom path aliasing
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# custom path aliasing for pip installed packages
PATH="/Users/simonbein/.local/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/simonbein/.sdkman"
[[ -s "/Users/simonbein/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/simonbein/.sdkman/bin/sdkman-init.sh"

[[ -s "/Users/simonbein/.gvm/scripts/gvm" ]] && source "/Users/simonbein/.gvm/scripts/gvm"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/simonbein/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/simonbein/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/simonbein/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/simonbein/google-cloud-sdk/completion.zsh.inc'; fi

# Initialize pyenv paths
eval "$(pyenv init -)"

# Automatically reset the cursor to beam after exiting vim
autoload -U add-zsh-hook
function vim () {
  printf "\x1b[\x36 q" 
}
add-zsh-hook -Uz precmd vim

# Custom fzf parsing
unalias gco
gco() {
  local tags branches target
  if (( $# > 0 )); then
	  git checkout $@
	  return
  fi
  branches=$(
    git --no-pager branch --sort=-committerdate \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  # tags=$(
  #   git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}
