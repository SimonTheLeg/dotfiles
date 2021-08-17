# Collection of dotfiles and other settings

## Linking common dotfiles

simply run the script

```shell
./linkall.sh
```

## On a new system

### One time setup

1. Install nix. Note for future Simon: With nix 2.4 this feature will be moved upstream

  ```sh
  sh <(curl https://abathur-nix-install-tests.cachix.org/serve/yihf8zbs0jwph2rs9qfh80dnilijxdi2/install) --tarball-url-prefix https://abathur-nix-install-tests.cachix.org/serve
  ```

### For each user on the system one time

1. Clone the repository into `~/simontheleg/`

  ```sh
  git clone https://github.com/SimonTheLeg/dotfiles.git ~/simontheleg
  ```

2. Add the unstable channel as nixpkgs

  ```sh
  nix-channel --add https://channels.nixos.org/nixpkgs-unstable nixpkgs
  nix-channel --update
  ```

3. Symlink home manager config and [Install Home Manager](https://github.com/nix-community/home-manager#installation)

  ```sh
  ln -s -f <DOTFILES_REPO_PATH>/home.nix ${HOME}/.config/nixpkgs/home.nix
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
  ```

4. Start home-manager environment generation

  ```sh
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  home-manager switch
  ```
