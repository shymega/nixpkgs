{ multiStdenv
, pkgs
, lib
, fetchurl
, python3
, python3Packages
, desktop-file-utils
, gcc_multi
, glibc_multi
, gtk3
, libICE
, libSM
, libX11
, libXext
, libXi
, freetype
, libpng
, zlib
, lcms2
, libGL
, libXcursor
, libXrandr
, libGLU
, gst_all_1
, autoPatchelfHook
, openalSoft
, alsa-lib
, ocl-icd
, sane-backends
, libusb
, libgphoto2
}:

# This package installs as a trial version valid for 14 days.
# You'll be able to sign in to unlock the software if you have a license.
# It's possible to obtain a license from the companys website.
let
  myPython = python3.withPackages (ps: [ ps.pygobject3 ps.dbus-python ]);
in
multiStdenv.mkDerivation rec {
  pname = "crossover";
  version = "22.0.1";

  src = fetchurl {
    url =
      "https://media.codeweavers.com/pub/${pname}/cxlinux/demo/${pname}_${version}-1.deb";
    sha256 = "d30a4cff82c27e37992e0b7410219d46e2f760f134810ff6a2dcd4909f41fdd6";
  };

  unpackPhase = ''
    ar x $src
    tar xf data.tar.xz
  '';

  nativeBuildInputs = [ python3 desktop-file-utils autoPatchelfHook ];
  buildInputs = [
    gcc_multi
    glibc_multi
    myPython
    python3Packages.dbus-python
    python3Packages.pygobject3
    gtk3
    libICE
    libSM
    libX11
    libXext
    libXi
    freetype
    libpng
    zlib
    lcms2
    libGL
    libXcursor
    libXrandr
    libGLU
    openalSoft
    alsa-lib
    ocl-icd
    sane-backends
    libusb
    libgphoto2
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly

  ];
  propagatedBuildInputs = [
    python3
    gcc_multi
    glibc_multi
    python3Packages.dbus-python
    python3Packages.pygobject3
    gtk3
  ];

  patchPhase = ''
    substituteInPlace opt/cxoffice/bin/crossover \
      --replace "python3" "${lib.getBin myPython}/bin/python3"
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -a opt/cxoffice/{bin,lib,share,doc} $out/
    cp -a usr/share/*/ $out/share/    
  '';

  meta = with lib; {
    homepage = "https://www.codeweavers.com/products/crossover-linux";
    license = licenses.unfree;
    description = "Easy-to-use container-based GUI for Wine";
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ louisdk1 ];
  };
}

