{ lib, flake-parts-lib, ...}:
let
  inherit (lib) mkOption mkEnableOption types;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({pkgs, config, ...}: {
      options = {
        extraPackages = mkOption {
          description = ''
            Set of top-level packages either not in standard nixpkgs or using pinned versions
          '';
          type = types.lazyAttrsOf types.package;
          default = {};
        };

        poetryPlugins = mkOption {
          description = ''
            Set of poetry plugin packages to be used with `poetry.withPlugins`
          '';
          type = types.lazyAttrsOf types.package;
          default = {};
        };

        extraPython3Packages = mkOption {
          description = ''
            Set of python3 packages not in standard nixpkgs
          '';
          type = types.lazyAttrsOf types.package;
          default = {};
        };
      };

      config = {
        _module.args = {
          # utility to create a bundled poetry package with plugins
          poetryWithPlugins = selector: pkgs.poetry.withPlugins (_: selector config.poetryPlugins);
        };

        # expose built-in supported poetry plugins by default
        poetryPlugins = pkgs.poetry.plugins;
      };
    });
  };

  imports = [
    ./modules/nixpkgs.nix
    ./modules/odbc.nix
    ./pkgs/fly
    ./pkgs/python
  ];
}