{ lib, fetchFromGitHub, cmake, curl, xorg, avahi, qt5, openssl, stdenv
, wrapGAppsHook
, avahiWithLibdnssdCompat ? avahi.override { withLibdnssdCompat = true; }
, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "input-leap";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "input-leap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2tHqLF3zS3C4UnOVIZfpcuzaemC9++nC7lXgFnFSfKU=";
    fetchSubmodules = true;
  };

  patches = [
    # This patch can be removed when a new version of inputleap (greater than 2.4.0)
    # is released, which will contain this commit.
    (fetchpatch {
      name = "add-missing-cstddef-header.patch";
      url =
        "https://github.com/input-leap/inputleap/commit/4b12265ae5d324b942698a3177e1d8b1749414d7.patch";
      sha256 = "sha256-ajMxP7szBFi4h8cMT3qswfa3k/QiJ1FGI3q9fkCFQQk=";
    })
  ];

  buildInputs = [
    curl
    xorg.libX11
    xorg.libXext
    xorg.libXtst
    avahiWithLibdnssdCompat
    qt5.qtbase
  ];
  nativeBuildInputs = [ cmake wrapGAppsHook qt5.wrapQtAppsHook ];

  postFixup = ''
    substituteInPlace "$out/share/applications/inputleap.desktop" --replace "Exec=inputleap" "Exec=$out/bin/inputleap"
  '';

  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ openssl ]}" ];

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
