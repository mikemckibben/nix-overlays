{
  perSystem = { pkgs, ... }: {
    poetryPlugins = {
      poetry-monorepo-dependency-plugin = with pkgs; python3Packages.buildPythonPackage rec {
        pname = "poetry-monorepo-dependency-plugin";
        version = "1.1.0";
        format = "pyproject";
        src = ./src;
        nativeBuildInputs = with python3Packages; [poetry-core cleo installer];
        doCheck = false;
      };
    };
  };
}