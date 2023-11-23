{ stdenv
, lib
, fetchurl
, xorg
, freetype
, fontconfig
, zlib
, patchelf
}:
stdenv.mkDerivation rec {
  pname = "moneydance";
  version = "2023_5005";

  src = fetchurl {
    url = "https://infinitekind.com/stabledl/${version}/Moneydance_linux_amd64.tar.gz";
    sha256 = "sha256-/hWaY7kKyNswgqh+0Tzg8Jb7duyk5Pfpx79dFLCZMB0=";
  };

  nativeBuildInputs = [ patchelf ];

  dontConfigure = true;
  dontBuild = true;
  dontInstall = true;

  unpackPhase = ''
    mkdir -p "$out"
    tar xfvz "$src" --strip-components=1 -C "$out"
  '';

  preFixup =
    let
      jreLibPath = lib.makeLibraryPath [
        fontconfig
        freetype
        xorg.libX11
        xorg.libXext
        xorg.libXi
        xorg.libXrender
        xorg.libXtst
        zlib
      ];
    in
    ''
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "$out/jre/lib:${jreLibPath}" "$out"/jre/bin/*
      patchelf --set-rpath "$out/jre/lib:${jreLibPath}" "$out"/jre/lib/*.so
    '';

  meta = with lib; {
    description = "Moneydance ${version}";
    homepage = "https://infinitekind.com/moneydance";
    maintainers = [ "shymega" ];
    license = licenses.unfree;
  };
}
