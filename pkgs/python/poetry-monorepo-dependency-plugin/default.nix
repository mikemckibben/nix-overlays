{
  perSystem = { pkgs, ... }: {
    poetryPlugins = {
      poetry-monorepo-dependency-plugin = with pkgs; python3Packages.buildPythonPackage rec {
        pname = "poetry-monorepo-dependency-plugin";
        version = "1.1.0";
        format = "pyproject";
        src = fetchFromGitHub {
          owner = "TechnologyBrewery";
          repo = "poetry-monorepo-dependency-plugin";
          rev = "${pname}-${version}";
          hash = "sha256-oTvZ/fNBiLQNLAuc1CEhi6rA5N5AsxdjK/Z5HobxedI=";
        };
        nativeBuildInputs = with python3Packages; [poetry-core cleo installer];
        doCheck = false;
      };
    };
  };
}