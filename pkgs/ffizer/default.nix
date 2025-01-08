{
  perSystem = { inputs', pkgs, ... }: {

    packages.ffizer =
      let
        inherit (pkgs.rustPackages.rustPlatform) buildRustPackage;
        toolchain = inputs'.fenix.packages.stable.toolchain;
        rustPlatform = pkgs.makeRustPlatform {
          cargo = toolchain;
          rustc = toolchain;
        };
        version = "2.13.0";
      in
        rustPlatform.buildRustPackage rec {
          inherit version;
          name = "ffizer";
          src = pkgs.fetchFromGitHub {
            owner = "ffizer";
            repo = "ffizer";
            rev = version;
            hash = "sha256-Kgd27X9t/AkNCkVWCHdNO6MJBLchxrPQkkmqEJVTrPo=";
          };
          cargoLock.lockFile = "${src}/Cargo.lock";
          buildFeatures = ["cli"];
          nativeBuildInputs = with pkgs; [ perl ];
        };
  };
}
