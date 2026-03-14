# Aggregates all package categories and resolves them against nixpkgs.
# Version declarations are verified against the actual nixpkgs versions.
# A warning is printed for any mismatch, helping detect drift after nixpkgs updates.
{ pkgs, isDarwin }:

let
  resolve = specs: map (spec:
    let
      pkg = builtins.getAttr spec.attr pkgs;
    in
      if pkg.version != spec.version then
        builtins.trace
          "WARNING: ${spec.attr} version mismatch: declared ${spec.version}, actual ${pkg.version}"
          pkg
      else
        pkg
  ) specs;

in
  resolve (import ./cli.nix)
  ++ resolve (import ./development.nix)
  ++ resolve (import ./kubernetes.nix)
  ++ resolve (import ./cloud.nix)
  ++ resolve (import ./editors.nix)
  ++ resolve (import ./networking.nix)
  ++ resolve (import ./media.nix)
  ++ resolve (import ./nix-tools.nix)
  ++ resolve (import ./security.nix)
  ++ (if isDarwin then resolve (import ./macos.nix) else [])
