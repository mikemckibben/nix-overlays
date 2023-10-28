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

    });
  };

  imports = [
    ./modules/nixpkgs.nix
    ./modules/odbc.nix
    ./pkgs/cloudfoundry-cli
    ./pkgs/fly
    ./pkgs/python
  ];

  config = {
    perSystem = {config, pkgs, ...}: {
      _module.args = {
        # utility to create a bundled poetry package with plugins
        poetryWithPlugins = selector: pkgs.poetry.withPlugins (ps: selector (ps // config.poetryPlugins));
      };
    };
  };
}