{ config, lib, ... }:

let
  username = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";
  # Currently I have fixated this to $HOME/code/github/simontheleg/dotfiles to sync it across multiple machines and/or
  # multiple users per machine, as it only comes with the limitation to always clone the repository into
  # that directory
  dotFilesDir = "${homeDir}/code/github/simontheleg/dotfiles";

  # Nixpkgs source pins are defined in nix/nixpkgs.nix
  nixpkgsSources = import ./nix/nixpkgs.nix;

  pkgs = import (builtins.fetchGit nixpkgsSources.stable) {
    config = { allowUnfree = true; };
  };

  pkgs_unstable = import (builtins.fetchGit nixpkgsSources.unstable) {
    config = { allowUnfree = true; };
    overlays = [ ];
  };

in {
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

  # Package definitions with individual version tracking are in nix/packages/
  home.packages = import ./nix/packages {
    pkgs = pkgs_unstable;
    isDarwin = pkgs.stdenv.isDarwin;
  };

  home.file = {
    ".zprofile".source = "${dotFilesDir}/.zprofile";
    ".tmux.conf".source = "${dotFilesDir}/.tmux.conf";
    ".gitconfig".source = "${dotFilesDir}/.gitconfig";
    ".gitignore".source = "${dotFilesDir}/.global-gitignore";
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink
      "${dotFilesDir}/starship.toml"; # mkOutOfStoreSymlink is needed so starship can write into the file
    # since I am playing around with nvim the whole day, keep this as a symlink for now
    ".config/nvim/".source =
      config.lib.file.mkOutOfStoreSymlink "${dotFilesDir}/nvim/";
    ".kube/kubie.yaml".source = "${dotFilesDir}/kubie.yaml";
    ".config/fish/config.fish".source =
      config.lib.file.mkOutOfStoreSymlink "${dotFilesDir}/config.fish";

    ".tmux/plugins/tpm".source = config.lib.file.mkOutOfStoreSymlink
      (pkgs.fetchFromGitHub {
        owner = "tmux-plugins";
        repo = "tpm";
        rev = "v3.0.0";
        sha256 = "sha256-qYBMDLIEkgiTFxjlF8AHn31HZ4nt/ZoeerzX70SSBaM=";
      });

    "Library/Application Support/k9s/skins/OneDark.yaml".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/derailed/k9s/v0.27.4/skins/one_dark.yml";
        sha256 = "sha256-527BS3aU+2MmbnHXNzCYQ1b47cDistd5+2xuIXUQmpU=";
      };

    ".iterm2_shell_integration.zsh".source = pkgs.fetchurl {
      url = "https://iterm2.com/shell_integration/zsh";
      sha256 = "sha256-kQJ8bVIh7nEjYJ6OWqiEDqIY+YWD5RbD1CXV+KKyDno";
    };

    ".rupaz/z.sh".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/rupa/z/v1.11/z.sh";
      sha256 = "sha256-8k4HkboQ9qgwFGHaP8UDM+7i4Amhnl0OnzZh8NBEZ2c=";
    };

    # needed for the absolute insanity that is the MacOS last login feature
    ".hushlogin" = {
      text = "";
    };

    # experimental section TODO at one point I'll have to decide between ghostty and kitty
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dotFilesDir}/ghostty/";

    ".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotFilesDir}/kitty.conf";

  };

  programs.zsh = {
    enable = true;

    autosuggestion = {
      enable = true;
    };

    localVariables = {
      # disable escape when pasting urls. See https://stackoverflow.com/questions/25614613/how-to-disable-zsh-substitution-autocomplete-with-url-and-backslashes
      DISABLE_MAGIC_FUNCTIONS = [ "true" ];
    };

    initExtra = builtins.readFile "${dotFilesDir}/.zshrc";

    oh-my-zsh = { enable = true; };

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
