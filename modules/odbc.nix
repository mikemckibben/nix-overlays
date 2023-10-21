{ lib, flake-parts-lib, ...}:
let
  inherit (lib) concatMapStringsSep mkIf mkOption mkOptionDefault mkEnableOption types;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({pkgs, config, ...}:
    let
      mkUnixODBCInst = concatMapStringsSep "\n" (pkg:
        ''
          [${pkg.fancyName}]
          Description = ${pkg.meta.description}
          Driver = ${pkg}/${pkg.driver}
        ''
      );
    in
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
        };
      };

      config = mkIf (config.odbc.enable && (builtins.length config.odbc.drivers) != 0) {
        packages.odbc = mkOptionDefault (pkgs.writeText "odbcinst.ini" (mkUnixODBCInst config.odbc.drivers));
      };
    });
  };

}