# Load also bash completion funcs (zsh completion funcs will automatically be loaded by home-manager)
autoload -U bashcompinit && bashcompinit

# Set language to English for tools like git
export LC_ALL=en_US.UTF-8

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
alias gpf='git push --force-with-lease'
alias gl="git lg"
alias gc='git commit'
alias gco='git checkout'
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
alias gio='git-open'
alias gst='git stash --all'
alias gstp='git stash --pop'

GH_COM_USERNAME="SimonTheLeg"
GH_SAP_USERNAME="C5385163"

gh_username_from_local_clone() {
  if git remote -v | grep github.com &> /dev/null; then GH_USERNAME=$GH_COM_USERNAME; fi
  if git remote -v | grep github.tools.sap &> /dev/null; then GH_USERNAME=$GH_SAP_USERNAME; fi
}

determine_repo_vars() {
  LOCAL_PREFIX="${HOME}/code/github"
  GH_USERNAME=$GH_COM_USERNAME
  CLONE_PATH_PREFIX="" # for github.com, no prefix is required
  SERVER_PREFIX="" # for github.com, no prefix is required

  export ORG REPO BUFFER
  IFS=/ read -r ORG REPO BUFFER <<< $1
  ORG=${ORG:l} # since org is case insensitive in GH, lowercase it so we don't have two folders for the same org by accident

  REPO_ID="${ORG}/${REPO}"
  
  if [ "$ORG" = "sap" ] ; then 
    LOCAL_PREFIX="${HOME}/code/sap"
    # shift all the arguments one over
    ORG=$REPO
    REPO=$BUFFER
    GH_USERNAME=$GH_SAP_USERNAME
    CLONE_PATH_PREFIX="https://github.tools.sap/"
    SERVER_PREFIX="sap/"
  fi

  LOCAL_FOLDER="${LOCAL_PREFIX}/${ORG}/${REPO}"
  CLONE_STRING="${CLONE_PATH_PREFIX}${ORG}/${REPO}"
}

gbackup() {
  CUR_BRANCH=$(git branch --show-current)
  BACKUP_BRANCH="${CUR_BRANCH}_backup"
  echo "Creating Backup Branch ${BACKUP_BRANCH}"
  git switch -c $BACKUP_BRANCH
  git switch $CUR_BRANCH
}

gpr() {
  gh_username_from_local_clone
  # check if we are on a fork
  if git remote -v | grep upstream &> /dev/null; then
    gh pr view ${GH_USERNAME}:$(git branch --show-current) --web || gh pr create --web --head ${GH_USERNAME}:$(git branch --show-current)
  else
    gh pr view $(git branch --show-current) --web || gh pr create --web
  fi
}

ghc() {
  determine_repo_vars $1
 
  # use its own shell here so we can stop execution on error
  (
  set -e
  gh repo clone "${CLONE_STRING}" "${LOCAL_FOLDER}"
  cd "${LOCAL_FOLDER}"
  # if we are on a fork, initialize the repo with upstream
  if git remote -v | grep upstream &> /dev/null; then
    upstream_url=$(git remote get-url --push upstream)
    gh repo set-default ${upstream_url}
  fi
  )
  # after successful cloning, change the current shell into the new directory
  cd "${LOCAL_FOLDER}"
}

ghf() {
  (
  determine_repo_vars $1

  set -e
  if [ -z "$2" ]
    then
      gh repo fork --clone=false "${CLONE_STRING}"
      FORKNAME="${SERVER_PREFIX}${GH_USERNAME}/${REPO}"
    else
      # if a custom name is provided, supply it to the fork
      gh repo fork --clone=false "${CLONE_STRING}" --fork-name "${2}"
      FORKNAME="${SERVER_PREFIX}${GH_USERNAME}/${2}"
  fi
  sleep 3s # sometimes the fork is already created, but not ready for cloning yet, but gh cli will finish early (only really happens on private servers)
  ghc "${FORKNAME}"
)

  cd "${LOCAL_FOLDER}"
}

tempgo() {
  DATE=$(date +"%d-%m_%H-%M-%S")
  DIR="${HOME}/go-experiments/${DATE}" # unfortunately this cannot be in /tmp, because dlv cannot use breakpoints in symbolic links
  mkdir -p ${DIR}
  cd ${DIR}
  git init
  go mod init github.com/SimonTheLeg/go-tests
  cat << EOF > main.go
package main

import (
	"fmt"
	"os"
)

func main() {
	if err := execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func execute() error {
	return nil
}
EOF
  code . main.go
}

# Kubernetes Aliases
alias kc='kubectl'
alias k='kubectl'
alias kcd='kubectl describe'
alias kcl='kubectl logs'
alias kcg='kubectl get'
alias wkc='watch kubectl'
alias kcwn='kc get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,NODE:.spec.nodeName'
alias k9s='k9s --logoless'
# done as a func instead of alias, so I don't have to deal with escaping all the quotes
knd() {
  kubectl create deploy debug-pod --image=simontheleg/debug-pod:latest && kubectl wait --for=condition=ready pod -l app=debug-pod && kubectl exec -it $(kubectl get pods -o jsonpath="{.items[?(@.metadata.labels.app=='debug-pod')].metadata.name}") -- /bin/bash
}

kecho() {
  namespace=$(kubectl config view --minify -o jsonpath='{..namespace}')
  kubectl create deploy debug-echo-server --image=ealen/echo-server
  kubectl expose deployment debug-echo-server --port 80
  echo "server available via:"
  echo "debug-echo-server.${namespace}"
  echo "debug-echo-server.${namespace}.svc.cluster.local"
}
#
# [konsole] create root shell on a node
function konsole() {
    alias _inline_fzf="fzf --multi --ansi -i -1 --height=50% --reverse -0 --header-lines=1 --inline-info --border"
    local node_hostname="$(kubectl get node --label-columns=kubernetes.io/hostname | _inline_fzf | awk '{print $6}')"
    local ns="$(kubectl get ns | _inline_fzf | awk '{print $1}')"
    local name=shell-$RANDOM
    local overrides='
{
    "spec": {
        "hostPID": true,
        "hostNetwork": true,
        "tolerations": [
            {
                "operator": "Exists",
                "effect": "NoSchedule"
            },
            {
                "operator": "Exists",
                "effect": "NoExecute"
            }
        ],
        "containers": [
            {
                "name": "'$name'",
                "image": "alpine",
                "command": [
                    "/bin/sh"
                ],
                "args": [
                    "-c",
                    "nsenter -t 1 -m -u -i -n -p -- bash"
                ],
                "resources": null,
                "stdin": true,
                "stdinOnce": true,
                "terminationMessagePath": "/dev/termination-log",
                "terminationMessagePolicy": "File",
                "tty": true,
                "securityContext": {
                    "privileged": true
                }
            }
        ],
        "nodeSelector": {
            "kubernetes.io/hostname": "'$node_hostname'"
        }
    }
}
'
    kubectl run $name --namespace "$ns" --rm -it --image alpine --overrides="${overrides}"
}

# Change `kubectl edit` editor to vim
export KUBE_EDITOR='nvim'

# iTerm shell integration (https://www.iterm2.com/documentation-shell-integration.html)
source ~/.iterm2_shell_integration.zsh

# Stern autocompletion
source <(stern --completion=zsh)

# Exa alias
alias ls='exa'
alias exa='exa --long --git'

# fd alias
alias find='fd'

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
# use a symlink intead of an alias for podman, so I can use it in bash scripts which I cannot change
ln -sf /Users/simonbein/.nix-profile/bin/podman /usr/local/bin/docker

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

# additional versions can be installed via go install golang.org/dl/go<VERSION>@latest
# add the location where all go versions are to path
export PATH=${HOME}/go/bin:${PATH}
# set the default go version to use with plain "go" commands
alias gohelper=go1.23.6
export PATH=$(gohelper env GOROOT)/bin:${PATH} # simple alias go=go1.22.6 is not enough as some tools explicitedly search for the go binary inside $PATH
export GOROOT=$(gohelper env GOROOT)
export PATH=$(gohelper env GOPATH)/bin:${PATH}

# source plugins installed by krew
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


# dj prow setup
source <(dj completion zsh)

prowlogs() {
  konf set k8c-dev-ci_k8c-dev-ci &&
  dj logs $1
}

prowproxy() {
  konf set k8c-dev-ci_k8c-dev-ci &&
  dj kind-proxy $1
}

prowusercluster() {
  konf set k8c-dev-ci_k8c-dev-ci
  tempfile=$(mktemp)
  echo $tempfile
  dj kkp-usercluster $1 > $tempfile
}

# rupa/z
source $HOME/.rupaz/z.sh
