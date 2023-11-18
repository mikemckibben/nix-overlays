{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
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

      perSystem = { self', config, ... }:
      {
        packages = config.extraPackages;

        devshells.default = {
          packages = [] ++ (builtins.attrValues config.extraPackages);
        };

      };
    });
}