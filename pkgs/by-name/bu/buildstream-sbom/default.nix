{
  python3Packages,
  buildPythonApplication,
  fetchFromGitLab,
  buildstream,
  ...
}:
buildPythonApplication (finalAttrs: {
  pname = "buildstream-sbom";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "buildstream";
    repo = "buildstream-sbom";
    tag = finalAttrs.version;
    hash = "sha256-Eo9aoJFdYFQWE6K/C44Q45XUDH0R8I+Hxqu0EHkbIbk=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    buildstream
  ];

  propagatedBuildInputs = [
    python3Packages.pyyaml
  ];
})
