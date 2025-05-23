{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-auth-oauthlib,
  google-auth,
  pythonOlder,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "pydata-google-auth";
  version = "1.9.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "pydata-google-auth";
    owner = "pydata";
    tag = version;
    hash = "sha256-NxEpwCkjNWao2bnKOsDgw93N+cVqwM12VfoEu8CyWUU=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    google-auth
    google-auth-oauthlib
  ];

  # tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pydata_google_auth" ];

  meta = with lib; {
    description = "Helpers for authenticating to Google APIs";
    homepage = "https://github.com/pydata/pydata-google-auth";
    changelog = "https://github.com/pydata/pydata-google-auth/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
  };
}
