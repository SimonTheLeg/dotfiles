{ config, pkgs, ... }:

let
  username = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";
  # Currently I have fixated this to $HOME/simontheleg/dotfiles to sync it across multiple machines and/or
  # multiple users per machine, as it only comes with the limitation to always clone the repository into
  # that directory
  dotFilesDir = "${homeDir}/simontheleg/dotfiles";
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDir;

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

  # Workaround to get yarn 1.19.2 (and node 12.x) running for current setup. Might make sense to use a custom nix file and nix-shell for the future.
  nixpkgs.overlays = [ 
    (self: super: {
      yarn = super.yarn.override { nodejs = pkgs.nodejs-12_x; };
    })
  ];

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
    istioctl
    jq
    json2hcl
    kubectl
    kubie
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
    awscli2
    operator-sdk
    kubernetes-helm
    kind
    fluxcd
    zsh-z
    kustomize
    asciinema
  ];

  home.file = {
    ".tmux.conf".source = "${dotFilesDir}/.tmux.conf";
    ".vimrc".source = "${dotFilesDir}/.vimrc";
    ".gitconfig".source = "${dotFilesDir}/.gitconfig";
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotFilesDir}/starship.toml"; # mkOutOfStoreSymlink is needed so starship can write into the file
    ".config/nvim/init.vim".source = "${dotFilesDir}/init.vim";
    ".kube/kubie.yaml".source = "${dotFilesDir}/kubie.yaml";

    ".goenv/".source = pkgs.fetchFromGitHub {
      owner = "syndbg";
      repo = "goenv";
      rev = "abde8693ab55aef279d19f5bf0a146c414bac45b";
      sha256 = "sha256-Jb0x0cLEA6c0hfq9M2EeE25jE55m0rvqjNLMfedQdI4=";
    };

    ".tmux/plugins/tpm".source = config.lib.file.mkOutOfStoreSymlink ( pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tpm";
      rev = "v3.0.0";
      sha256 = "sha256-qYBMDLIEkgiTFxjlF8AHn31HZ4nt/ZoeerzX70SSBaM=";
    });

    ".local/share/nvim/site/autoload/plug.vim".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";
      sha256 = "sha256-VgaLrLphI8TsVB85iJM/3cf5wee0+bCmfzrZPf1t9L4=";
    };

    ".iterm2_shell_integration.zsh".source = pkgs.fetchurl {
      url = "https://iterm2.com/shell_integration/zsh";
      sha256 = "sha256-pNn1unJyAU8QihQoHV7aIZA1s2iyloAG9hdV19/zaMA=";
    };

  };

  programs.zsh = {
    enable = true;

    initExtra = builtins.readFile "${dotFilesDir}/.zshrc";

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
      {
        name = "zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.0";
          sha256 = "sha256-eRTk0o35QbPB9kOIV0iDwd0j5P/yewFFISVS/iEfP2g=";
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
