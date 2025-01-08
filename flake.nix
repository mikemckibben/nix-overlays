{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    fenix.url = "github:nix-community/fenix";
  };

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } ({flake-parts-lib, withSystem, ...}:
    let
      inherit (flake-parts-lib) importApply;
      flakeModules.default = importApply ./flake-module.nix {};
    in
    {
      systems = import inputs.systems;
      imports = [
        flake-parts.flakeModules.flakeModules
        inputs.devshell.flakeModule
        flakeModules.default
      ];

      flake = {
        inherit flakeModules;
      };

      perSystem = { self', inputs', config, poetryWithPlugins, pkgs, ... }:
      {
        pythonPackage = pkgs.python3;

        packages.fenix-stable = inputs'.fenix.packages.stable;
        packages.fenix-nightly = inputs'.fenix.packages.complete;

        devshells.default = {
          packages = [];
        };

        devshells.allPackages = {
          packages = (builtins.attrValues self'.packages);
        };

        devshells.poetryPlugins =
        let
          poetry' = poetryWithPlugins (ps: with ps; [
            poetry-plugin-up
            poetry-monorepo-dependency-plugin
          ]);
        in
        {
          packages = [poetry'];
        };

      };
    });
}
