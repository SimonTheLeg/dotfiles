# Collection of dotfiles and other settings

## One time setup

1. Install nix. Note for future Simon: With nix 2.4 this feature will be moved upstream

  ```sh
  sh <(curl https://abathur-nix-install-tests.cachix.org/serve/yihf8zbs0jwph2rs9qfh80dnilijxdi2/install) --tarball-url-prefix https://abathur-nix-install-tests.cachix.org/serve
  ```

## For each user on the system one time

1. Clone the repository into `~/simontheleg/`

  ```sh
  git clone git@github.com:SimonTheLeg/dotfiles.git ~/simontheleg/dotfiles
  ```

2. Add a channel as nixpkgs. This is mainly to make home-manager happy. It does not server any further purpose, as all channels used are pinned in `home.nix`:

  ```sh
  nix-channel --add https://channels.nixos.org/nixos-21.11 nixpkgs
  nix-channel --update
  ```

3. Symlink home manager config and [Install Home Manager](https://github.com/nix-community/home-manager#installation)

  ```sh
  mkdir -p ${HOME}/.config/nixpkgs/
  ln -s -f ~/simontheleg/dotfiles/home.nix ${HOME}/.config/nixpkgs/home.nix
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  nix-shell '<home-manager>' -A install
  ```

4. Start home-manager environment generation

  ```sh
  home-manager switch
  ```
