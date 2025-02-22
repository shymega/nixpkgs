{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  libiconv,
  numpy,
  scipy,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "clarabel";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DW0/6IAL5bS11AqOFL1JJmez5GzF2+N2d85e0l8HGdQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-a8BXdA5rOjQRvacPRmobHxedHWNFZVyNN1xit+N8q3Y=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "clarabel" ];

  # no tests but run the same examples as .github/workflows/pypi.yaml
  checkPhase = ''
    runHook preCheck
    python examples/python/example_sdp.py
    python examples/python/example_qp.py
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/oxfordcontrol/Clarabel.rs/releases/tag/v${version}/CHANGELOG.md";
    description = "Conic Interior Point Solver";
    homepage = "https://github.com/oxfordcontrol/Clarabel.rs";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
