{
  perSystem = { pkgs, ... }: {
    extraPackages.cloudfoundry-cli-v7 = with pkgs; callPackage ({ lib, buildGoModule, fetchFromGitHub, fetchurl, installShellFiles }:
      buildGoModule rec {
        pname = "cloudfoundry-cli";
        version = "7.7.4";

        src = fetchFromGitHub {
          owner = "cloudfoundry";
          repo = "cli";
          rev = "v${version}";
          sha256 = "sha256-5H54q9WOIYqzwkCfLDDUML1unGxsO0sFweufc4YTVb8=";
        };

        vendorHash = "sha256-g6lXD/wGCQXOx3fmLTEQFaE5p1RUxfbv71AyaUYlNUc=";

        subPackages = [ "." ];

        nativeBuildInputs = [ installShellFiles ];

        postInstall = ''
          mv "$out/bin/cli" "$out/bin/cf7"
        '';

        ldflags = [
          "-s"
          "-w"
          "-X code.cloudfoundry.org/cli/version.binaryBuildDate=1970-01-01"
          "-X code.cloudfoundry.org/cli/version.binaryVersion=${version}"
        ];
      }
    ) {};

    extraPackages.cloudfoundry-cli-v6 = with pkgs; callPackage ({ lib, buildGoModule, fetchFromGitHub, fetchurl, installShellFiles }:
      buildGoModule rec {
        pname = "cloudfoundry-cli";
        version = "6.53.0";

        src = fetchFromGitHub {
          owner = "cloudfoundry";
          repo = "cli";
          rev = "v${version}";
          sha256 = "sha256-1IFufrKZvKlbgyoItOnapNCOTWqvV62BH+3q8d1oMtw=";
        };

        vendorHash = "sha256-SgYU6aLkXaWyC9H3FQWJg9b3nTmarF170qOgXzyON6I=";

        subPackages = [ "." ];

        patches = [
          ./patch-6.53.0
        ];

        postPatch = ''
          rm -rf vendor
        '';

        nativeBuildInputs = [ installShellFiles ];

        postInstall = ''
          mv "$out/bin/cli" "$out/bin/cf6"
        '';

        ldflags = [
          "-s"
          "-w"
          "-X code.cloudfoundry.org/cli/version.binaryBuildDate=1970-01-01"
          "-X code.cloudfoundry.org/cli/version.binaryVersion=${version}"
        ];
      }
    ) {};
  };


}