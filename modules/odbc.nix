{ lib, flake-parts-lib, perSystem, ...}:
let
  inherit (lib) concatMapStringsSep mkIf mkOption mkDefault mkEnableOption types;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({pkgs, config, ...}:
    {
      options = {
        odbc = mkOption {
          description = ''
            config option to control generating an odbcinst.init onfiguration package derivation
          '';
          type = types.submodule {
            options = {
              enable = mkEnableOption "odbc";
              drivers = mkOption {
                description = ''
                Set of unixODBC driver packages to include in the odbcinst.ini system configuration
                '';
                type = types.listOf types.package;
                default = [];
              };
            };
          };
          default = { enable = false; };
        };
      };
    });
  };

  config = {
    perSystem = { config, lib, pkgs, ... }:
    let
      mkUnixODBCInst = concatMapStringsSep "\n" (pkg:
        ''
          [${pkg.fancyName}]
          Description = ${pkg.meta.description}
          Driver = ${pkg}/${pkg.driver}
        ''
      );
      cfg = config.odbc;
    in
    {
      packages.odbc = mkIf (cfg.enable && (builtins.length cfg.drivers) != 0) (mkDefault (pkgs.writeText "odbcinst.ini" (mkUnixODBCInst cfg.drivers)));
    };
  };
}