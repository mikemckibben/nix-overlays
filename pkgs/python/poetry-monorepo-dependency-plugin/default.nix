{
  perSystem = { pkgs, config, ...}: {
    poetryPlugins.poetry-monorepo-dependency-plugin = config.poetryPackage.python.pkgs.callPackage (
      {buildPythonPackage, fetchPypi, poetry, poetry-core, cleo}:
      buildPythonPackage rec {
        pname = "poetry-monorepo-dependency-plugin";
        version = "1.1.0";
        format = "pyproject";
        src = fetchPypi {
          pname = builtins.replaceStrings ["-"] ["_"] pname;
          inherit version;
          hash = "sha256-fPBJidRKa69/Om2/u33F3flQtoTUYJmarn0ntv6Lwgo=";
        };
        buildInputs = [poetry-core cleo];
        nativeCheckInputs = [poetry];
      }
    ) {};
  };
}