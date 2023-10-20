{
  perSystem = { pkgs, ... }: {

    # latest nixpkg has as top-level application
    poetryPlugins.poetry-poethepoet-plugin = pkgs.poethepoet;

  };
}