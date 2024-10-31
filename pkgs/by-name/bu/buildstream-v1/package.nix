{ lib
, makeWrapper
, fetchPypi
, binutils
, fuse2
, lzip
, patch
, python310Packages
, bubblewrap
, buildbox
}:
let
  inherit (python310Packages) buildPythonApplication buildPythonPackage;
  pytest-runner = buildPythonPackage rec {
    pname = "pytest-runner";
    version = "6.0.1";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-cNRzlYWnAI83v0kzwBP9sye4h4paafy7MxbIiILw9Js=";
    };
    build-system = with python310Packages; [ setuptools setuptools-scm ];
  };
in
buildPythonApplication
rec {
  pname = "BuildStream";
  version = "1.6.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rEYGwCbpbBBMeSpRdsETSHGivDxQVm/PSFW5DmEZtGA=";
  };

  build-system = with python310Packages; [ setuptools ];

  dependencies = with python310Packages; [
    click
    fusepy
    grpcio
    jinja2
    markupsafe
    pluginbase
    protobuf
    psutil
    ruamel-yaml
    ruamel-yaml-clib
    six
    ujson
  ] ++ lib.singleton pytest-runner;

  nativeBuildInputs =
    (with python310Packages; [
      pdm-pep517
      setuptools-scm
    ]) ++ [
      bubblewrap
    ];

  buildInputs = lib.singleton makeWrapper;

  propagatedBuildInputs =
    [
      lzip
      patch
      buildbox
      binutils
    ]
    ++ (with python310Packages; [
      cython
      fusepy
    ]);

  LD_LIBRARY_PATH = "${lib.makeLibraryPath [fuse2]}";

  doCheck = false;

  makeWrapperArgs = [
    "--set LD_LIBRARY_PATH ${LD_LIBRARY_PATH}"
  ];

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
