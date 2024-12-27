{
  bubblewrap,
  buildbox,
  fetchFromGitLab,
  fuse3,
  lib,
  lzip,
  patch,
  pdm,
  pkg-config,
  protobuf,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "girderstream";
  version = "${pname}-v0.1.0";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "willsalmon/stop_build";
    hash = "sha256-Uca1Ek+rmouJ0M/T/ni1c6n9kOBjTQfCTf2kyLaPoRQ=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  propagatedBuildInputs = [
    bubblewrap
    buildbox
    fuse3
    lzip
    patch
  ];

  nativeBuildInputs = [pkg-config protobuf];

  doCheck = false;

  meta = {
    platforms = lib.platforms.linux;
    mainProgram = "girderstream";
    maintainers = with lib.maintainers; [shymega];
  };
}
