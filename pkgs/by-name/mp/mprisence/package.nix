{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprisence";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w5cMNLYsMeuSNZ4RyWZnAHsGANCZ5oGq1+VQ5LZv2+M=";
  };

  cargoHash = "sha256-Wf2FY9olNrrrz+WZKsNalzUpdJnBzVv5e9QgXaOJCp8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    dbus
  ];

  postInstall = ''
    mkdir --parents $out/lib/systemd/user
    substitute $src/mprisence.service $out/lib/systemd/user/mprisence.service \
      --replace-fail "@BINDIR@/mprisence" "$out/bin/mprisence"
  '';

  meta = {
    description = " A highly customizable Discord Rich Presence for MPRIS media players on Linux";
    homepage = "https://github.com/lazykern/mprisence";
    changelog = "https://github.com/lazykern/mprisence/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.shymega ];
    mainProgram = "mprisence";
  };
})
