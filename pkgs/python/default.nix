{ inputs, lib, flake-parts-lib, ...}:
let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{

  imports = [
    ./poetry-monorepo-dependency-plugin
  ];

  perSystem = { pkgs, ... }: {

    # expose built-in supported poetry plugins
    poetryPlugins = pkgs.poetry.plugins;

  };
}