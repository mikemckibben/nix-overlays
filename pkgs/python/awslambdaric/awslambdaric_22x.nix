{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  pytestCheckHook,
  autoconf271,
  automake,
  cmake,
  gcc,
  libtool,
  parameterized,
  perl,
  setuptools,
  simplejson
}:
buildPythonPackage rec {
  pname = "awslambdaric";
  version = "2.2.1";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-python-runtime-interface-client";
    rev = "refs/tags/${version}";
    sha256 = "sha256-IA2Kx4+U0+8lPl9TTTZC46Y3WhSUb5HR5Hr9QZSJIDU=";
  };

  propagatedBuildInputs = [ simplejson ];

  nativeBuildInputs = [
    autoconf271
    automake
    cmake
    libtool
    perl
    setuptools
  ];

  buildInputs = [ gcc ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "awslambdaric"
    "runtime_client"
  ];

  meta = with lib; {
    broken = stdenv.isLinux && stdenv.isAarch64;
    description = "AWS Lambda Runtime Interface Client for Python";
    homepage = "https://github.com/aws/aws-lambda-python-runtime-interface-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
    platforms = platforms.linux;
  };
}