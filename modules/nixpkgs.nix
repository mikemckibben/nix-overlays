#nixpkgs.config
{ lib, flake-parts-lib, inputs, ...}:
let
  inherit (lib) concatMapStringsSep mkIf mkOption mkOptionDefault mkEnableOption types;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({config, system, ...}:
    {
      options = {
        nixpkgs = mkOption {
          description = ''
            option for configuration of nixpkgs
          '';
          type = types.submodule {
            options = {
              config = mkOption {
                description = ''
                nixpkgs configuration options
                '';
                type = types.attrsOf types.anything;
                default = {};
              };
            };
          };
        };
      };

      config = mkIf (config.nixpkgs.config != {}) {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          inherit (config.nixpkgs) config;
        };
      };
    });
  };

}