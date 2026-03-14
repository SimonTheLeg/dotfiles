# Nixpkgs source pins
# Update these to change the base package versions available.
# Find commits at: https://github.com/NixOS/nixpkgs/commits
{
  stable = {
    name = "nixpkgs-stable";
    url = "https://github.com/nixos/nixpkgs.git";
    ref = "refs/heads/nixpkgs-23.05-darwin";
    rev = "b7589ceaeea275918c209db1c9a2c51e327af1ee";
  };

  unstable = {
    name = "nixpkgs-unstable";
    url = "https://github.com/nixos/nixpkgs.git";
    # nixpkgs-unstable 28.02.2026
    ref = "refs/heads/master";
    rev = "c0f3d81a7ddbc2b1332be0d8481a672b4f6004d6";
  };
}
