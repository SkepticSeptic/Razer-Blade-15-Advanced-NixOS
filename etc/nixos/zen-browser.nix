{ pkgs }:

let
  version = "1.11.5b";
  downloadUrl = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-x86_64.tar.xz";
  sha256 = "9840082fded87c9d47d8e6497ba5665594eb6492a06f7fe45a68c5e591d4e647";
  # sha256 = "0000000000000000000000000000000000000000000000000000";
  # change to this with every release to find new hash
  # nix --extra-experimental-features nix-command hash to-base16 sha256-<NIXOS-REBUILD-EXPECTED-HASH>
  # probably insecure idk lol supply chain attacks are wack
 
  runtimeLibs = with pkgs; [
    libGL libGLU libevent libffi libjpeg libpng libstartup_notification libvpx libwebp
    stdenv.cc.cc fontconfig libxkbcommon zlib freetype
    gtk3 libxml2 dbus xcb-util-cursor alsa-lib libpulseaudio pango atk cairo gdk-pixbuf glib
    udev libva mesa libnotify cups pciutils
    ffmpeg libglvnd pipewire
  ] ++ (with pkgs.xorg; [
    libxcb libX11 libXcursor libXrandr libXi libXext libXcomposite libXdamage
    libXfixes libXScrnSaver
  ]);

in pkgs.stdenv.mkDerivation {
  pname = "zen-browser";
  inherit version;

  src = pkgs.fetchurl {
    url = downloadUrl;
    sha256 = sha256;
  };
  sourceRoot = "zen";

  nativeBuildInputs = [
    pkgs.makeWrapper
    pkgs.copyDesktopItems
    pkgs.wrapGAppsHook
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./* $out/bin

  '';

  fixupPhase = ''
    chmod 755 $out/bin/*

    for prog in zen zen-bin glxtest updater vaapitest; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/$prog
      wrapProgram $out/bin/$prog --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
        --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = {
    description = "Zen Browser";
    homepage = "https://github.com/zen-browser/desktop";
    license = pkgs.lib.licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ ];
    platforms = pkgs.lib.platforms.linux;
    mainProgram = "zen";
  };
}
