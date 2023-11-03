{
  perSystem = { pkgs, ... }: {
    poetryPlugins.poetry-monorepo-dependency-plugin = with pkgs; python3Packages.buildPythonPackage rec {
      pname = "poetry-monorepo-dependency-plugin";
      version = "1.1.0";
      format = "pyproject";
      src = fetchPypi {
        pname = builtins.replaceStrings ["-"] ["_"] pname;
        inherit version;
        hash = "sha256-fPBJidRKa69/Om2/u33F3flQtoTUYJmarn0ntv6Lwgo=";
      };
      nativeBuildInputs = with python3Packages; [poetry-core cleo installer];
      doCheck = false;
    };
  };
}