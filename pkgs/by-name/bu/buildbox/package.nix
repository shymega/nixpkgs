{
  lib,
  stdenv,
  fetchFromGitLab,
  bubblewrap,
  makeWrapper,
  cmake,
  pkg-config,
  ninja,
  grpc,
  gbenchmark,
  gtest,
  protobuf,
  glog,
  nlohmann_json,
  zlib,
  openssl,
  libuuid,
  tomlplusplus,
  fuse3,
}:
let
  pname = "buildbox";
  version = "1.2.35";
in
stdenv.mkDerivation {
  inherit pname version;

  buildInputs = [
    cmake
    pkg-config
    ninja
    bubblewrap
    grpc
    gbenchmark
    gtest
    glog
    protobuf
    nlohmann_json
    zlib
    openssl
    libuuid
    tomlplusplus
    fuse3
  ];
  nativeBuildInputs = lib.singleton makeWrapper;

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "BuildGrid";
    repo = "${pname}/${pname}";
    tag = "${version}";
    hash = "sha256-xsMsChMjwkS2y6zmkqt6QU7qUTRtP8/NDK5kLVr+Elo=";
  };

  postFixup = ''
    wrapProgram $out/bin/buildbox-run-bubblewrap --prefix PATH : ${lib.makeBinPath [ bubblewrap ]}
    ln -sf buildbox-run-bubblewrap $out/bin/buildbox-run
  '';

  meta = with lib; {
    description = "A set of tools for remote worker build execution.";
    homepage = "https://gitlab.com/BuildGrid/buildbox/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ shymega ];
  };
}
