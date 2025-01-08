{
  perSystem = { pkgs, config, ...}: {
    packages.awslambdaric_22x = config.pythonPackage.pkgs.callPackage ./awslambdaric_22x.nix {};
  };
}
