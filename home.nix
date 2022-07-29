{ config, ... }:

let
  username = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";
  # Currently I have fixated this to $HOME/simontheleg/dotfiles to sync it across multiple machines and/or
  # multiple users per machine, as it only comes with the limitation to always clone the repository into
  # that directory
  dotFilesDir = "${homeDir}/simontheleg/dotfiles";

  # pin stable and unstable channels to specific commits
  nixstablecommit = "3c5ae9be1f18c790ea890ef8decbd0946c0b4c04";
  nixunstablecommit = "934e076a441e318897aa17540f6cf7caadc69028";
  
  pkgs = import (builtins.fetchGit {
       name = "nixpkgs-stable";
       url = "https://github.com/nixos/nixpkgs.git";
       ref = "refs/heads/nixos-21.11";
       rev = "${nixstablecommit}";
  }) {
      config= { allowUnfree = true ; } ;
  };

  pkgs_unstable = import (builtins.fetchGit {
       name = "nixpkgs-unstable";
       url = "https://github.com/nixos/nixpkgs.git";
       ref = "refs/heads/nixpkgs-unstable";
       rev = "${nixunstablecommit}";
  }) {
      config= { allowUnfree = true ; } ;
      overlays = [
        (self: super: {

          # currently needed as buildGo18Module is not yet supported in Darwin (https://github.com/NixOS/nixpkgs/issues/168984)
          golangci-lint = super.golangci-lint.override {
            buildGoModule = super.buildGoModule;
          };

          # Switch to yq version 3 for Kubermatic. Might make sense to extract this into a custom nix file for directoy nix-shell in the future
          yq-go3 =
            let
              version = "3.4.1";
              src = pkgs.fetchFromGitHub {
              owner = "mikefarah";
              repo = "yq";
              rev = version;
              sha256 = "sha256-K3mWo5wFKWxSel8y/b6N02/BoB/KuTbHhVJrVYLCbCY=";
              };
            in
              (pkgs.yq-go.override rec {
                buildGoModule = args: pkgs.buildGoModule.override {} (args // {
                  inherit src version;
                  vendorSha256 = "sha256-jT0/4wjpj5kBULXIC+bupHOnp0n9sk4WJAC7hu6Cq1A=";
                });
              });

        })
      ];
    };

in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDir;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  home.packages = with pkgs_unstable; [
    apg
    azure-cli
    bash
    bat
    cachix
    dhall-lsp-server
    diff-so-fancy
    direnv
    dive
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
    istioctl
    jq
    json2hcl
    kubectl
    librsvg
    lorri
    minikube
    moreutils
    mtr
    mycli
    neovim
    niv
    nnn
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
    vault
    yq-go3
    prometheus
    kubebuilder
    htop
    sops
    krew
    sonobuoy
    act
    findutils
    bash-completion
    imagemagick
    gifsicle
    pv
    coreutils
    grpcurl
    git-filter-repo
    nixfmt
    python310
    k9s
    highlight
    graphviz
    goreleaser
    minio-client
    rakkess
  ];
  # for future Simon: if I ever need more than one channel as source, here's how to do it https://discourse.nixos.org/t/nix-env-i-runs-out-of-memory-with-unstable-overlay/1517/3

  home.file = {
    ".zprofile".source = "${dotFilesDir}/.zprofile";
    ".tmux.conf".source = "${dotFilesDir}/.tmux.conf";
    ".vimrc".source = "${dotFilesDir}/.vimrc";
    ".gitconfig".source = "${dotFilesDir}/.gitconfig";
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotFilesDir}/starship.toml"; # mkOutOfStoreSymlink is needed so starship can write into the file
    ".config/nvim/init.vim".source = "${dotFilesDir}/init.vim";
    ".kube/kubie.yaml".source = "${dotFilesDir}/kubie.yaml";

    ".goenv/".source = pkgs.fetchFromGitHub {
      owner = "syndbg";
      repo = "goenv";
      rev = "c3d01c40bd3d0201add312fad1bab21494df8a7d";
      sha256 = "sha256-dDEk0Eh8nOO5IgolTarRKWWLwK1ns0Ns0VJztAl0uos=";
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

    ".rupaz/z.sh".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/rupa/z/v1.11/z.sh";
      sha256 = "sha256-8k4HkboQ9qgwFGHaP8UDM+7i4Amhnl0OnzZh8NBEZ2c=";
    };

  };

  programs.zsh = {
    enable = true;

    initExtra = builtins.readFile "${dotFilesDir}/.zshrc";

    oh-my-zsh = {
      enable = true;
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
    ];
  };
}
