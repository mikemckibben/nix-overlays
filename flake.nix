{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    fly = {
      url = "github:concourse/concourse/v6.7.6";
      flake = false;
    };

    poetry-monorepo-dependency-plugin = {
      url = "github:TechnologyBrewery/poetry-monorepo-dependency-plugin/poetry-monorepo-dependency-plugin-1.1.0";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        flake-parts.flakeModules.easyOverlay
        ./pkgs/fly
        ./pkgs/python
      ];
    };
}