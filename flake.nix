{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";

    # subpackage overlays
    fly.url = "./pkgs/fly";
    fly.inputs.nixpkgs.follows = "nixpkgs";
    fly.inputs.flake-utils.follows = "flake-utils";
  };

  outputs =  { self, nixpkgs, flake-utils, devshell, ... }@inputs:
  let
    inherit (builtins) attrNames attrValues foldl';

    composeExtensions = f: g: final: prev:
      let
        fApplied = f final prev;
        prev' = prev // fApplied;
      in fApplied // g final prev';

  in
    {
      overlays.default =
        foldl' composeExtensions (final: prev: { }) [inputs.fly.overlays.default];
    }
    //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default devshell.overlays.default ];
        };
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          fly6 = pkgs.fly6;
        };
        devShell = pkgs.devshell.mkShell {
          packages = attrValues packages;
        };
      }
    );
}