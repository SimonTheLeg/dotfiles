{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # Allow unfree packages as well
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    apg
    azure-cli
    bash
    bat
    cachix
    dhall-lsp-server
    diff-so-fancy
    direnv
    dive
    docker
    etcd
    exa
    fzf
    gettext
    gh
    git
    git-sizer
    gnugrep
    gnupg
    gnused
    gopass
    gradle
    hugo
    go
    istioctl
    jq
    json2hcl
    kubectl
    kubectx
    librsvg
    lorri
    minikube
    moreutils
    mtr
    mycli
    neovim
    niv
    nnn
    nodejs-12_x
    oh-my-zsh
    postgresql
    protobuf
    putty
    pwgen
    redis
    ripgrep
    shellcheck
    silver-searcher
    sox
    stack
    starship
    stern
    terraform
    terraform-docs
    terraform-ls
    tmux
    tree
    vim
    watch
    wget
    yarn
    nix-prefetch-github
    ngrok
    git-open
    scmpuff
    google-cloud-sdk
    google-clasp
  ];

  programs.zsh = {
    enable = true;

    initExtra = builtins.readFile /Users/simonbuilds/streams/dotfiles/.zshrc;

    # Reason why I want to manage oh-my-zsh in here instead of in .zshrc is simply to have both installation and management in a single place
    # Also I think this eliminiates traversing the fpath twice (once in standard nix and then once for oh-my-zsh)
    oh-my-zsh = {
      enable = true;
      plugins = [ "terraform" "gitfast" "colored-man-pages" "z" ];
    };

    # For now I have given up on managing all plugins and autocompletions via the zsh nix module. Reasons are:
    # - it seems really tough install completion packages. e.g. terraform has its own completions, which is not managed by the plugin it self (see https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/terraform. And I could not find a way to install this

    # For future Simon. You can use the `nix-prefetch-github --nix <gh-owner> <gh-repo> --rev <desired-git-ref>` command to find the revs and shas

    plugins = [
      {
        name = "zsh-autosuggestions";
        file = "zsh-autosuggestions.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      # {
      #   name = "zsh-autosuggestions";
      #   file = "zsh-autosuggestions.plugin.zsh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "zsh-users";
      #     repo = "zsh-autosuggestions";
      #     rev = "v0.7.0";
      #     sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
      #   };
      # }
      {
        name = "zsh-autocomplete";
        file = "zsh-autocomplete.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner ="marlonrichert";
          repo = "zsh-autocomplete";
          rev = "21.06.16";
          sha256 = "4HslOPaV+ko6riU8NDb9UIdemV7qhLez2jN/kOD04a0=";
        };
      }
      # {
      #   name = "scm_breeze";
      #   file = "scm_breeze.plugin.zsh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "scmbreeze";
      #     repo = "scm_breeze";
      #     rev = "759c70d9cb4f1d87a0e3929fc67d22881cf80885";
      #     sha256 = "16v70i6zcfw633wcmb31pfgflc00hg2h7km64rz1damvr63vyaqg";
      #   };
      # }
      # {
      #   name = "terraform";
      #   file = "plugins/terraform/terraform.plugin.zsh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "ohmyzsh";
      #     repo = "ohmyzsh";
      #     rev = "706b2f3765d41bee2853b17724888d1a3f6f00d9";
      #     sha256 = "06vfqp56s7xjv69vmn21man94vjx96zsg17x002zkmxjb4lfnkzh";
      #   };
      # }
    ];
  };
}
