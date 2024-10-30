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
    tag = version;
    hash = "sha256-9XPNGmQfzniwzOb1oiHiUEMHF0UX73or4c4/g8wFKvA=";
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
