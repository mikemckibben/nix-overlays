{ inputs, lib, flake-parts-lib, ...}:
let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{

  imports = [
    ./poetry-monorepo-dependency-plugin
    ./poetry-poethepoet-plugin
  ];

}