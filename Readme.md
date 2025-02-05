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

Aftewards reboot the Mac and then it should be available under the standard input sources

### Nix Setup

1. Install Nix:

  ```sh
  sh <(curl -L https://nixos.org/nix/install)
  ```

2. Symlink home manager config and [Install Home Manager](https://github.com/nix-community/home-manager#installation)

  ```sh
  mkdir -p ${HOME}/.config/nixpkgs/
  ln -s -f ~/code/github/simontheleg/dotfiles/home.nix ${HOME}/.config/home-manager/home.nix
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  nix-shell '<home-manager>' -A install
  ```

3. Start home-manager environment generation

  ```sh
  home-manager switch
  ```

### iTerm Setup

1. Install NerdFont

```sh
open iTerm/Meslo\ LG\ L\ DZ\ Regular\ Nerd\ Font\ Complete.ttf
```

2. In iTerm settings point the settings folder to the dotfiles/iTerm folder
