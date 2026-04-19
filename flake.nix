{
  description = "Minimal uutils-coreutils build with only essential tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        uutils-micro = pkgs.callPackage ./package.nix {};
      in {
        packages.default = uutils-micro;
        packages.uutils-micro = uutils-micro;
        overlays.default = final: prev: { uutils-micro = uutils-micro; };
      }
    );
}
