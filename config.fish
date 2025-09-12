if status is-interactive
    # disable fish greeting
    set fish_greeting

    set DOTFILES_DIR "$HOME/code/github/simontheleg/dotfiles"

    # at this point I have given up with all the nix-fish magick, so I just add the nix binaries manually to path
    set PATH $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin $PATH

    # init starship
    starship init fish | source

    # enable verbose logging on "vv"
    abbr -a --command={kubectl,k} --regex "vv" -- "kubectl_vv" "-v=6"
    abbr -a --command=curl --regex "vv" -- "curl_vv" "-v"

    # always include untracked files in git stash
    abbr -a --command="git" --regex "stash" -- "git_stash" "stash --include-untracked"

    # Go configurations
    # additional versions can be installed via go install golang.org/dl/go<VERSION>@latest
    # add the location where all go versions are to path
    set PATH $HOME/go/bin $PATH
    # set the default go version to use with plain "go" commands
    alias gohelper go1.24.0
    set PATH $(gohelper env GOROOT)/bin $PATH # simple alias go=go1.22.6 is not enough as some tools explicitedly search for the go binary inside $PATH
    set GOROOT $(gohelper env GOROOT)
    set PATH $(gohelper env GOPATH)/bin $PATH


    # Kubernetes settings
    alias k='kubectl'
    alias kd='kubectl describe'
    alias kl='kubectl logs'
    alias wk='watch kubectl'
    alias kwn='kc get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,NODE:.spec.nodeName'
    alias k9s='k9s --logoless'
    # k9s settings
    set K9S_SKIN OneDark
    # stern settings
    stern --completion=fish | source
    # source plugins installed by krew
    set PATH $HOME/.krew/bin $PATH

    # konf settings
    # mandatory konf settings
    konf-go shellwrapper fish | source
    # optional konf settings
    alias kctx="konf set"
    alias kns="konf ns"
    # Open last konf on new session (use --silent to suppress INFO log line)
    konf --silent set -
    # Autocompletion. Currently supported shells: zsh
    konf completion fish | source

    # Other Aliases
    alias ls='exa'
    alias exa='exa --long --git'
    # fd alias
    # -H include hidden files
    # -I include .gitignore files
    alias find='fd -IH'
    # replace cat with bat
    alias cat='bat --theme "TwoDark"'
    alias cl='clear'
    alias tf='tofu'
    alias dc='docker-compose'
    function mkcd
        mkdir $argv[1] && cd $argv[1]
    end

    # Podman settings
    # use a symlink intead of an alias for podman, so I can use it in bash scripts which I cannot change
    ln -sf /Users/simonbein/.nix-profile/bin/podman /usr/local/bin/docker

    # NeoVim settings
    alias vim="nvim"
    set EDITOR nvim

    # fish tracing/debugging
    abbr -a ft fish_trace=on
    # TODO change this later to non manual path
    alias rr "source ~/.config/fish/config.fish"

    # configure colors
    set fish_color_command green
    set fish_color_param white
    set fish_color_operator white

    # enable vi mode
    set -g fish_key_bindings fish_vi_key_bindings

    # # make vi-mode work with system clipboard
    # bind -M normal yy fish_clipboard_copy
    # bind p fish_clipboard_paste
    # bind -s --preset -M visual -m default y "fish_clipboard_copy; commandline -f end-selection repaint-mode"

    # Git aliases and settings
    alias gs='scmpuff_status'
    alias ga='git add'
    alias gb='git branch'
    alias gd='git diff'
    alias gp='git push'
    alias gpf='git push --force-with-lease'
    alias gl='git lg'
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
    alias gsf='git diff-tree --no-commit-id --name-status -r'
    alias gf='git fetch'
    alias gfa='git fetch --all'
    alias gio='git-open'
    alias gst='git stash --all'
    alias gstp='git stash --pop'
    # Source scmpuff
    scmpuff init --shell=fish | source

    # GitHub settings
    set -gx GH_COM_USERNAME SimonTheLeg
    set -gx GH_SAP_USERNAME C5385163

    function gh_username_from_local_clone
        if git remote -v | grep github.com &>/dev/null
            set -gx GH_USERNAME $GH_COM_USERNAME
        else if git remote -v | grep github.tools.sap &>/dev/null
            set -gx GH_USERNAME $GH_SAP_USERNAME
        end
    end

    function determine_repo_vars
        set LOCAL_PREFIX "$HOME/code/github"
        set -gx GH_USERNAME $GH_COM_USERNAME
        set -gx CLONE_PATH_PREFIX "" # for github.com, no prefix is required
        set -gx SERVER_PREFIX "" # for github.com, no prefix is required

        # TODO maybe one day I find a better way for this
        set -gx ORG (string split '/' $argv[1] -f 1)
        set -gx REPO (string split '/' $argv[1] -f 2)
        set -gx BUFFER (string split '/' $argv[1] -f 3)
        # set ORG REPO BUFFER (string split '/' $argv[1])
        set ORG (string lower $ORG) # since org is case insensitive in GH, lowercase it so we don't have two folders for the same org by accident

        if [ $ORG = sap ]
            set LOCAL_PREFIX "$HOME/code/sap"
            # shift all the arguments one over
            set ORG $REPO
            set REPO $BUFFER
            set GH_USERNAME $GH_SAP_USERNAME
            set CLONE_PATH_PREFIX "https://github.tools.sap/"
            set SERVER_PREFIX sap/
        end

        set -gx LOCAL_FOLDER "$LOCAL_PREFIX/$ORG/$REPO"
        set -gx CLONE_STRING "$CLONE_PATH_PREFIX$ORG/$REPO"
    end

    function ghc
        determine_repo_vars $argv[1]

        # just fish things with the "ands" ¯\_(ツ)_/¯
        # https://github.com/fish-shell/fish-shell/issues/510
        gh repo clone "$CLONE_STRING" "$LOCAL_FOLDER"
        and cd "$LOCAL_FOLDER"
        # if we are on a fork, initialize the repo with upstream
        and if git remote -v | grep upstream &>/dev/null
            set upstream_url $(git remote get-url --push upstream)
            and gh repo set-default $upstream_url
        end
        # after successful cloning, change the current shell into the new directory
        and cd "$LOCAL_FOLDER"
    end

    function ghf
        determine_repo_vars $argv[1]

        set CUSTOM_FORK_NAME $argv[2]

        if not test -n "$CUSTOM_FORK_NAME"
            gh repo fork --clone=false "$CLONE_STRING"
            and set -gx FORKNAME "$SERVER_PREFIX$GH_USERNAME/$REPO"
        else
            # if a custom name is provided, supply it to the fork
            gh repo fork --clone=false "$CLONE_STRING" --fork-name "$CUSTOM_FORK_NAME"
            and set -gx FORKNAME "$SERVER_PREFIX$GH_USERNAME/$CUSTOM_FORK_NAME"
        end
        sleep 1s # sometimes the fork is already created, but not ready for cloning yet, but gh cli will finish early (only really happens on private servers)
        ghc "$FORKNAME"
    end

    function gpr
        gh_username_from_local_clone
        # check if we are on a fork
        if git remote -v | grep upstream &>/dev/null
            gh pr view $GH_USERNAME:$(git branch --show-current) --web || gh pr create --web --head $GH_USERNAME:$(git branch --show-current)
        else
            gh pr view $(git branch --show-current) --web || gh pr create --web
        end
    end

    function gbackup
        set CUR_BRANCH $(git branch --show-current)
        set BACKUP_BRANCH "$CUR_BRANCH""_backup"
        echo "Creating Backup Branch $BACKUP_BRANCH"
        git switch -c $BACKUP_BRANCH
        git switch $CUR_BRANCH
    end

    function gsw
        set -l tags
        set -l branches
        set -l target

        # if we already supply a branch, just switch to it
        if [ (count $argv) -gt 0 ]
            git switch $argv[1]
            return
        end

        # otherwise open the branch picker
        set branches $(git --no-pager branch --sort=-committerdate \
                          --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
                            | sed '/^$/d') || return

        set target $(
            echo "$branches"; echo "$tags" |
            fzf --no-hscroll --no-multi -n 2 \
            --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
        echo $target
        # git switch $(awk '{print $2}' <<<"$target" )
    end

    function tempgo -d "Setup a temporary Go project for testing"
        set DATE $(date +"%d-%m_%H-%M-%S")
        set DIR "$HOME/go-experiments/$DATE" # unfortunately this cannot be in /tmp, because dlv cannot use breakpoints in symbolic links
        mkdir -p $DIR
        cd $DIR
        git init
        go mod init github.com/SimonTheLeg/go-tests
        cp $DOTFILES_DIR/tempgo.template.go $DIR/main.go
        code . --goto "main.go:16"
    end

    function godebug -d "Build target arg1 with debug flags and start binary with arg2.."
        go build -o debug -gcflags="all=-N -l" $argv[1] && ./debug $argv[2..]
    end

end
