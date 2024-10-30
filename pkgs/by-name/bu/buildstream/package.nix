{
  python3Packages,
  fetchPypi,
  fetchFromGitLab,
  lzip,
  patch,
  bubblewrap,
  fuse3,
  lib,
  pdm,
  buildbox,
}:
let
  inherit (python3Packages) buildPythonApplication buildPythonPackage;
  pyroaring = buildPythonPackage rec {
    pname = "pyroaring";
    version = "1.0.0";
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-rzdDTTuZHOXBZ/AZLTVnEoZoZk9MTxsS3b6Be4BETI0=";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ cython ];
    nativeBuildInputs = with python3Packages; [
      pdm-pep517
      setuptools-scm
      pip
    ];
    meta = {
      platforms = lib.platforms.linux;
    };
  };
in
buildPythonApplication rec {
  pname = "buildstream";
  version = "2.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-crjsC66S4L42dejUQQ+i9j4+W68JF9Dn6kezaN3EZF8=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    click
    dulwich
    grpcio
    jinja2
    markupsafe
    packaging
    pluginbase
    protobuf
    psutil
    pyroaring
    requests
    ruamel-yaml
    ruamel-yaml-clib
    tomlkit
    ujson
  ];

  propagatedBuildInputs = [
    buildbox
    fuse3
    lzip
    patch
    python3Packages.cython
  ];

  nativeBuildInputs = with python3Packages; [
    bubblewrap
    pdm-pep517
    setuptools-scm
  ];

  doCheck = false;

  meta = {
    description = "BuildStream is a powerful software integration tool that allows developers to automate the integration of software components including operating systems, and to streamline the software development and production process.";
    downloadPage = "https://buildstream.build/install.html";
    homepage = "https://buildstream.build/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "bst";
    maintainers = with lib.maintainers; [ shymega ];
  };
}
