{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "flake-utils";
    src = {
      url = "github:concourse/concourse/v6.7.6";
      flake = false;
    };
  };

  outputs =  { self, nixpkgs, flake-utils, devshell, ... }@inputs:
    {
      overlays.default = final: prev: {
        fly = with final; buildGoModule rec {
          pname = "fly";
          version = "6.7.6";
          src = inputs.src;
          doCheck = false;
          subPackages = [ "fly" ];
          vendorSha256 = "sha256-Eyet5cXRpJxFQxiouPNUJcqr9VuQD+yR3vFgISg29Ok=";
          # vendorSha256 = lib.fakeSha256;
          ldflags= ["-X github.com/concourse/concourse.Version=${version}"];

          patches = [ ./patch-6.7.6 ];

          # prePatch = ''
          #   echo "replacing golang.org/x/sys module"
          #   go mod edit -go=1.17 -replace golang.org/x/sys=golang.org/x/sys@
          #   cat go.mod
          # '';

        };
      };
    }
    //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default devshell.overlay ];
        };
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          fly = pkgs.fly;
        };
        defaultPackage = packages.fly;
        apps.fly = flake-utils.lib.mkApp { drv = packages.fly; };
        defaultApp = apps.fly;
        devShell = pkgs.devshell.mkShell {
          commands = [
            {
              name = "fly";
              help = "fly cli";
              command = "${packages.fly}/bin/fly";
            }
          ];
        };
      }
    );
}