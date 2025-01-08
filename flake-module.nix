{...}:
{ lib, flake-parts-lib, ...}:
let
  inherit (lib) mkOption mkEnableOption types;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({pkgs, config, ...}: {
      options = {

        poetryPackage = mkOption {
          description = ''
            The poetry package to use for poetry plugins
          '';
          type = types.package;
          default = pkgs.poetry;
        };

        pythonPackage = mkOption {
          description = ''
            The python package to use for building python packages
          '';
          type = types.package;
          default = pkgs.python3;
        };

        poetryPlugins = mkOption {
          description = ''
            Set of poetry plugin packages to be used with `poetry.withPlugins`
          '';
          type = types.lazyAttrsOf types.package;
          default = {};
        };

      };

    });
  };

  imports = [
    ./modules/nixpkgs.nix
    ./modules/odbc.nix
    ./pkgs/cloudfoundry-cli
    ./pkgs/ffizer
    ./pkgs/fly
    ./pkgs/python
  ];

  config = {
    perSystem = {config, pkgs, ...}: {
      _module.args = {
        # utility to create a bundled poetry package with plugins
        poetryWithPlugins = selector: config.poetryPackage.withPlugins (ps: selector (ps // config.poetryPlugins));
      };
    };
  };
}
