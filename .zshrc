# Load also bash completion funcs (zsh completion funcs will automatically be loaded by home-manager)
autoload -U bashcompinit && bashcompinit

# Source home-manager
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

# Load the starship theme
eval "$(starship init zsh)"

# Set the default user (removes the user@hostname part of the regular prompt)
DEFAULT_USER="simonbein"

# Alias NeoVim as Vim
alias vim=nvim
export EDITOR='nvim'

# Fix color for autocomplete in tmux
export TERM=xterm-256color

# Set up gs as alias for git
alias gs='scmpuff_status'
alias ga='git add'
alias gb='git branch'
alias gd='git diff'
alias gp='git push'
alias gpf='git push -f'
alias gl="git lg"
alias gc='git commit'
alias gcm='git commit --amend'
alias gcmn='git commit --amend --no-edit'
alias gdc='git diff --cached'
alias gap='git add -p'
alias gpl='git pull'
alias gsb='git switch -c'
alias grs='git restore'
alias grb='git rebase'
alias grbi='git rebase -i'
alias cdg='cd $(git rev-parse --show-cdup)'
alias gsf='git diff-tree --no-commit-id --name-only -r'
alias gf='git fetch'
alias gfa='git fetch --all'

gpr() {
  GH_USERNAME="SimonTheLeg"
  # check if we are on a fork
  if git remote -v | grep upstream &> /dev/null; then
    gh pr view ${GH_USERNAME}:$(git branch --show-current) --web || gh pr create --web --head ${GH_USERNAME}:$(git branch --show-current)
  else
    gh pr view $(git branch --show-current) --web || gh pr create --web
  fi
}

ghc() {
  GH_PATH="${HOME}/github"

  ORG=${1%%/*}
  REPO=${1##*/}
  ORG_LOWERCASE=${ORG:l} # since org is case insensitive in GH, lowercase it so we don't have two folders for the same org by accident
  LOCAL_PATH="${ORG_LOWERCASE}/${REPO}"
  gh repo clone $1 "${GH_PATH}/${LOCAL_PATH}"
}
}

# Kubernetes Aliases
alias kc='kubectl'
alias kcd='kubectl describe'
alias kcl='kubectl logs'
alias kcg='kubectl get'
alias wkc='watch kubectl'
alias kcwn='kc get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,NODE:.spec.nodeName'

# Change `kubectl edit` editor to vim
export KUBE_EDITOR='nvim'

# iTerm shell integration (https://www.iterm2.com/documentation-shell-integration.html)
source ~/.iterm2_shell_integration.zsh

# Stern autocompletion
source <(stern --completion=zsh)

# Exa alias
alias ls='exa'
alias exa='exa --long --git'

# Bat alias
alias cat='bat --theme "TwoDark"'
# autoload -U +X bashcompinit && bashcompinit

# Other Alias
alias cl='clear'
alias tf='terraform'
alias dc='docker-compose'
alias sp='spotify'
alias fk='fly -t k'
alias pass='gopass'

if [ -n "${commands[fzf-share]}" ]; then
  FZF_COMPLETION_TRIGGER='*'
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

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

# custom path aliasing for pip installed packages
PATH="${HOME}/.local/bin:$PATH"

# source goenv
export GOENV_ROOT="$HOME/.goversions"
PATH="$HOME/.goenv/bin:$PATH"
goenv init - | source /dev/stdin
export PATH="${PATH}:${HOME}/.krew/bin"

# Source scmpuff
scmpuff init -s --aliases=false | source /dev/stdin

# Automatically reset the cursor to beam after exiting vim
autoload -U add-zsh-hook
function vim () {
  printf "\x1b[\x36 q" 
}
add-zsh-hook -Uz precmd vim

# Custom fzf parsing
gsw() {
  local tags branches target
  if (( $# > 0 )); then
	  git switch $@
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
  git switch $(awk '{print $2}' <<<"$target" )
}

# kubectl autocomplete
source <(kubectl completion zsh)

# Enable direnv
eval "$(direnv hook zsh)"

# mandatory konf settings
source <(konf-go shellwrapper zsh)

# optional konf settings
# Alias
alias kctx="konf set"
alias kns="konf ns"
# Open last konf on new session (use --silent to suppress INFO log line)
konf --silent set -
# Autocompletion. Currently supported shells: zsh
source <(konf completion zsh)

# terraform auto-completion
complete -o nospace -C /Users/simonbein/.nix-profile/bin/terraform terraform

# rupa/z
source $HOME/.rupaz/z.sh
