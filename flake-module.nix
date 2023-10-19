{ lib, flake-parts-lib, ...}:
let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({ ...}: {
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

        python3Packages = mkOption {
          description = ''
            Set of python3 packages to add to python packageOverrides
          '';
          type = types.lazyAttrsOf types.package;
          default = {};
        };
      };
    });
  };

  imports = [
    ./pkgs/fly
    ./pkgs/python
  ];
}