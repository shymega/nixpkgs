{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  cython,
  pythonOlder,
  requests,
  tomli,
  nixosTests,
}:
buildPythonPackage (finalAttrs: {
  pname = "buildstream-plugins";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "buildstream-plugins";
    tag = finalAttrs.version;
    hash = "sha256-9FlSgGOSXhSAyVwVIRzd+rc1PytxKmrss36dxaswKvs=";
  };

  build-system = [
    cython
    setuptools
  ];

  # Per-plugin extras, matching requirements/plugin-requirements.txt upstream:
  # these are only needed by users of the corresponding source/element, not by
  # buildstream-plugins itself, so they're kept optional rather than forced on
  # everyone via `dependencies`.
  optional-dependencies = {
    # Cargo source: only needed on Python < 3.11, which lacks stdlib tomllib.
    cargo = lib.optionals (pythonOlder "3.11") [ tomli ];
    # Docker source.
    docker = [ requests ];
  };

  # `buildstream-plugins` is loaded by `buildstream` at runtime, so it
  # will always have `buildstream` in its environment when imported; it
  # is not declared as a `dependencies` entry here since `buildstream`
  # bundles `buildstream-plugins` by default, which would otherwise
  # cause infinite recursion between the two packages. Its test suite
  # (which does need `buildstream` present, and needs real `/dev/fuse`
  # access that the Nix build sandbox doesn't provide) is run as a NixOS
  # VM test instead; see `passthru.tests.pytest`.
  doCheck = false;

  pythonImportsCheck = [ "buildstream_plugins" ];

  passthru = {
    updateScript = gitUpdater {
      ignoredVersions = "dev";
    };

    tests.pytest = nixosTests.buildstream-plugins;
  };

  meta = {
    changelog = "https://github.com/apache/buildstream-plugins/blob/${finalAttrs.src.tag}/NEWS";
    description = "BuildStream plugins";
    homepage = "https://github.com/apache/buildstream-plugins";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shymega ];
  };
})
