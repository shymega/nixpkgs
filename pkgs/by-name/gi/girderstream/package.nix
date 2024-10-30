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
  version = "unstable";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "main";
    hash = "sha256-s/u0qU0l9der8go/pUr8BkB4nkBMUIxURJpy9L2cP1Q=";
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
