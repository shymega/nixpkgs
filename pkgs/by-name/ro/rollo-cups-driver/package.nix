{
  cups,
  fetchzip,
  lib,
  stdenv,
}:
let
  pname = "rollo-cups-driver";
  version = "1.8.4";

  src = fetchzip {
    url = "https://rollo-main.b-cdn.net/driver-dl/linux/rollo-cups-driver-${version}.tar.gz";
    hash = "sha256-BJ6yj59MiLMfbEkf+Ud4ypDWgskxjrXHJCfZIrlpDXU=";
  };

  meta = {
    description = "CUPS driver for Rollo label printers";
    homepage = "https://www.rollo.com/driver-linux/";
    license = with lib.licenses; gpl3Plus;
    maintainers = with lib.maintainers; [ shymega ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  buildInputs = [
    cups
  ];

  makeFlags = [
    "CUPS_DATADIR=${placeholder "out"}/share/cups"
    "CUPS_SERVERBIN=${placeholder "out"}/lib/cups"
  ];
}
