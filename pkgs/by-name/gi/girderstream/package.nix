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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "girderstream";
  version = "unstable";

  src = fetchFromGitLab {
    owner = "girderstream";
    repo = "girderstream";
    rev = "main";
    hash = "sha256-akH5rFN1wplHjAGduiBPPjgjA4rywcPuJ8IsMHV8MEA=";
  };

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
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

  meta = {
    platforms = lib.platforms.linux;
    mainProgram = "girderstream";
    maintainers = with lib.maintainers; [ shymega ];
  };
})
