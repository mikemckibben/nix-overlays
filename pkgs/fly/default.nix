{
  perSystem = { lib, pkgs, ... }: {
    extraPackages.fly6 = with pkgs; buildGoModule rec {
      pname = "fly";
      version = "6.7.6";
      src =  fetchFromGitHub {
        owner = "concourse";
        repo = "concourse";
        rev = "v${version}";
        hash = "sha256-rTLU4WkojH4vpJs9qNzxCDeivWH1r12Bt2PF+3Fx91Q=";
      };
      doCheck = false;
      subPackages = [ "fly" ];
      vendorSha256 = "sha256-QS7F2DIOoOYEOPzWieV94kEAvJX64ExSXvBtlRaFZIo=";
      # vendorSha256 = lib.fakeSha256;
      ldflags= [
        "-X github.com/concourse/concourse.Version=${version}"
      ];

      postInstall = ''
        mv "$out/bin/fly" "$out/bin/fly6"
      '';
    };

    extraPackages.fly7 = with pkgs; buildGoModule rec {
      pname = "fly";
      version = "7.6.0";
      src =  fetchFromGitHub {
        owner = "concourse";
        repo = "concourse";
        rev = "v${version}";
        hash = "sha256-Zi+gyO+2AKDgcfgYrzLskJYZ6hQKOVlOL7Y9nxH/pGg=";
      };
      doCheck = false;
      subPackages = [ "fly" ];
      vendorSha256 = "sha256-OF3parnlTPmcr7tVcc6495sUMRApSpBHHjSE/4EFIxE=";
      # vendorSha256 = lib.fakeSha256;
      ldflags= [
        "-X github.com/concourse/concourse.Version=${version}"
      ];

      postInstall = ''
        mv "$out/bin/fly" "$out/bin/fly7"
      '';
    };
  };
}