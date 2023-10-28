#nixpkgs.config
{ lib, config, flake-parts-lib, inputs, ...}:
let
  inherit (lib) concatMapStringsSep mkIf mkOption mkOptionDefault mkEnableOption types;
  cfg = config.nixpkgs;
in
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
      default = {};
    };
  };

  config = mkIf (cfg.config != {}) {
    perSystem = {system, ...}: {
      _module.args.pkgs =  import inputs.nixpkgs {
        inherit system;
        inherit (cfg) config;
      };
    };
  };
}