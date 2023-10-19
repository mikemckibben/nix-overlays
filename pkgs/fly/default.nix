{
  perSystem = { pkgs, ... }: {
    packages.fly6 = with pkgs; buildGoModule rec {
      pname = "fly";
      version = "6.7.6";
      src =  ./src;
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