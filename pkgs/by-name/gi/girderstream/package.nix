{
  rustPlatform,
  fetchFromGitLab,
  lzip,
  patch,
  bubblewrap,
  fuse3,
  lib,
  pdm,
  buildbox,
}:
rustPlatform.buildRustPackage rec {
  pname = "girderstream";
  version = "unstable";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "main";
    hash = "sha256-R0qYNYwHNrJKIWt5iIx6/q251ZLa9iHVSh/Q2vcgB1Y=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  propagatedBuildInputs = [
    buildbox
    fuse3
    lzip
    patch
  ];

  nativeBuildInputs = [
    bubblewrap
  ];

  doCheck = false;

  meta = {
    platforms = lib.platforms.linux;
    mainProgram = "girderstream";
    maintainers = with lib.maintainers; [ shymega ];
  };
}
