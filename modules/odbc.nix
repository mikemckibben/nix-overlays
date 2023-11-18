{ lib, flake-parts-lib, withSystem, perSystem, ...}:
let
  inherit (lib) concatMapStringsSep mkIf mkOption mkDefault mkEnableOption types optionalAttrs;
  inherit (flake-parts-lib) mkPerSystemOption mkTransposedPerSystemModule;

  odbcOptions = mkTransposedPerSystemModule {
    name = "odbc";
    option = mkOption {
      description = ''
      config option to control generating an odbcinst.ini onfiguration package derivation
      '';
      type = types.submodule {
        options = {
          enable = mkEnableOption "odbc";
          drivers = mkOption {
            description = ''
            set of unixODBC driver packages to include in the odbcinst.ini system configuration
            '';
            type = types.listOf types.package;
            default = [];
          };
        };
      };
    };
    file = ./odbc.nix;
  };
in
{
  imports = [
    odbcOptions
  ];

  perSystem = { config, pkgs, ... }:
    let
      # cfg = config.odbc;
      mkUnixODBCInst = concatMapStringsSep "\n" (pkg:
        ''
          [${pkg.fancyName}]
          Description = ${pkg.meta.description}
          Driver = ${pkg}/${pkg.driver}
        ''
      );
    in
    {
      odbc.enable = mkDefault false;

      packages = mkIf config.odbc.enable {
        odbcinst = mkDefault (pkgs.writeText "odbcinst.ini" (mkUnixODBCInst config.odbc.drivers));
      };
    };
}