{
  lib,
  pkgs,
  stdenv,
  fetchFromGitLab,
  fetchFromGitHub,
  libusb1,
  curl,
  openssl,
  libevdev,
  json_c,
  hidapi,
  wayland,
  cmake,
  pkg-config,
  python3,
  libffi,
  autoPatchelfHook,
  ...
}:
let
  arch =
    let
      inherit (pkgs.stdenv.hostPlatform) isx86_64 isLinux isAarch64;
    in
    if isAarch64 && isLinux then
      "aarch64"
    else if isx86_64 && isLinux then
      "x86_64"
    else
      throw "Unsupported system ${pkgs.stdenv.hostPlatform.system}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xrlinuxdriver";
  version = "2.9.4";

  src = fetchFromGitHub rec {
    owner = "wheaney";
    repo = "XRLinuxDriver";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-fbaNdv6vjRphYYSzbOYqmRK6c24hv1gkTh3xlql0VEU=";
    name = "${repo}-src";
  };

  nativeBuildInputs =
    let
      pythonEnv = python3.withPackages (ps: [ ps.pyyaml ]);
    in
    [
      cmake
      pkg-config
      pythonEnv
      autoPatchelfHook
    ];
  buildInputs = [
    curl
    hidapi
    json_c
    libevdev
    libffi
    libusb1
    openssl
    stdenv.cc.cc.lib
    wayland
  ];

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON"
  ];
  cmakeBuildDir = "build";
  cmakeBuildType = "RelWithDebInfo";

  installPhase = ''
    mkdir -p $out/bin $out/usr/lib/systemd/user $out/usr/lib/udev/rules.d $out/usr/lib/${arch}
    cp xrDriver ../bin/xr_driver_cli ../bin/xr_driver_verify $out/bin
    cp ../udev/* $out/usr/lib/udev/rules.d/
    cp ../lib/${arch}/* $out/usr/lib/${arch}/
    cp ../systemd/xr-driver.service $out/usr/lib/systemd/user/
    cp ${hidapi}/lib/libhidapi-hidraw.so.0 $out/usr/lib/
  '';

  preBuild = ''
    addAutoPatchelfSearchPath $out/usr/lib/${arch}
  '';

  postInstall = ''
    substituteInPlace $out/usr/lib/systemd/user/xr-driver.service \
      --replace-fail "ExecStart={bin_dir}/xrDriver" "ExecStart=$out/bin/xrDriver" \
      --replace-fail "{ld_library_path}" "$out/usr/lib/${arch}"
  '';

  doInstallCheck = false;
  # The default release is a script which will do an impure download
  # just ensure that the application can run without network

  meta = {
    homepage = "https://github.com/wheaney/XRLinuxDriver";
    license = lib.licenses.mit;
    description = "Linux service for interacting with XR devices.";
    mainProgram = "xrDriver";
    maintainers = with lib.maintainers; [ shymega ];
    platforms = lib.platforms.linux;
  };
})
