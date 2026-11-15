# Collection of dotfiles and other settings

## Setup

Clone the repository into `~/code/github/simontheleg/dotfiles`

  ```sh
  git clone git@github.com:SimonTheLeg/dotfiles.git ~/code/github/simontheleg/dotfiles
  ```

### Keyboard Layout Setup

```sh
sudo cp -r SimonsCustomKeyboardLayout.bundle /Library/Keyboard\ Layouts
```

Afterwards reboot the Mac and then it should be available under the standard input sources

### Nix Setup

1. Install Nix:

  ```sh
  sh <(curl -L https://nixos.org/nix/install)
  ```

2. Symlink home manager config and [Install Home Manager](https://github.com/nix-community/home-manager#installation)

  ```fish
  mkdir -p ${HOME}/.config/home-manager/
  ln -s -f ~/code/github/simontheleg/dotfiles/home.nix ${HOME}/.config/home-manager/home.nix
  # Important: the home-manager channel must match the nixpkgs release that `<nixpkgs>` points to
  # (check with `nix-instantiate --find-file nixpkgs` and reading its `.version` file).
  # Using `master` against an older nixpkgs leads to evaluation errors such as
  # "error: attribute 'genAttrs'' missing".
  nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
  nix-channel --update
  set -x NIX_PATH $HOME/.nix-defexpr/channels $NIX_PATH
  nix-shell '<home-manager>' -A install
  ```

3. Start home-manager environment generation

  ```sh
  home-manager switch
  ```

### iTerm Setup

1. Install Powerline Font

```sh
open iTerm/Meslo\ LG\ L\ DZ\ Regular\ for\ Powerline.ttf 
```

2. In iTerm settings point the settings folder to the dotfiles/iTerm folder
