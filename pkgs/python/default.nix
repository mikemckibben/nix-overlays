{ inputs, lib, flake-parts-lib, ...}:
let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({ options, config, extendModules, ...}: {
      options = {
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
    ./poetry-monorepo-dependency-plugin
  ];

}