{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  curl,
  gpgme,
  libarchive,
  bzip2,
  xz,
  attr,
  acl,
  libxml2,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "opkg";
  version = "0.7.0";

  src = fetchurl {
    url = "https://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    hash = "sha256-2XP9DxVo9Y+H1q7NmqlePh9gIUpFzuJnBL+P51fFRWc=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    curl
    gpgme
    libarchive
    bzip2
    xz
    attr
    acl
    libxml2
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  meta = with lib; {
    description = "Lightweight package management system based upon ipkg";
    homepage = "https://git.yoctoproject.org/cgit/cgit.cgi/opkg/";
    changelog = "https://git.yoctoproject.org/opkg/tree/NEWS?h=v${version}";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
