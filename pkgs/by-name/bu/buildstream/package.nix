{ python3Packages
, fetchPypi
, lzip
, patch
, bubblewrap
, fuse3
, lib
, pdm
, buildbox
,
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
    nativeBuildInputs = with python3Packages;
      [
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
  version = "2.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dj25ELy/79ouN8zRHvoSxX2XNdOgN5BNdbEiditIAro=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages;
    [
      click
      grpcio
      jinja2
      markupsafe
      pluginbase
      protobuf
      psutil
      ruamel-yaml
      ruamel-yaml-clib
      ujson
    ] ++ lib.singleton pyroaring;

  propagatedBuildInputs = [
    buildbox
    fuse3
    lzip
    patch
    python3Packages.cython
  ];

  nativeBuildInputs = with python3Packages;
    [
      pdm-pep517
      setuptools-scm
    ] ++ lib.singleton bubblewrap;

  doCheck = false;

  meta = with lib; {
    description = "BuildStream is a powerful software integration tool that allows developers to automate the integration of software components including operating systems, and to streamline the software development and production process.";
    downloadPage = "https://buildstream.build/install.html";
    homepage = "https://buildstream.build/";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "bst";
    maintainers = with maintainers; [ shymega ];
  };
}
