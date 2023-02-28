{ lib
, fetchFromGitHub
, cmake
, pkg-config
, curl
, xorg
, avahi
, qtbase
, qttools
, wrapQtAppsHook
, openssl
, stdenv
, wrapGAppsHook
, avahiWithLibdnssdCompat ? avahi.override { withLibdnssdCompat = true; }
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "input-leap";
  version = "unstable-2023-03-07";

  src = fetchFromGitHub {
    owner = "input-leap";
    repo = "input-leap";
    rev = "09eebd619c5858d61e956fdb87f7cfabf7823b86";
    sha256 = "sha256-9ssD+6ipJnAWwgI32n/9rU4uG/mCqibfjktI0lt7gg8==";
    fetchSubmodules = true;
  };

  buildInputs = [
    curl
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXtst
    xorg.libXi
    xorg.libICE
    xorg.libSM
    avahiWithLibdnssdCompat
    qtbase
    qttools
  ];
  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook wrapQtAppsHook ];

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by qt5’s mkDerivation
  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
        --prefix PATH : "${lib.makeBinPath [ openssl ]}"
    )
  '';

  meta = {
    description = "Open-source KVM software";
    longDescription = ''
      Input Leap is KVM software forked from Symless's synergy 1.9 codebase.
      Synergy was a commercialized reimplementation of the original
      CosmoSynergy written by Chris Schoeneman.
    '';
    homepage = "https://github.com/input-leap/input-leap";
    downloadPage = "https://github.com/input-leap/input-leap/releases";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.phryneas ];
    platforms = lib.platforms.linux;
  };
}
