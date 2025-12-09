{
  appimageTools,
  fetchurl,
  stdenv,
}: let
  inherit (stdenv.hostPlatform) system;

  sourcesMap = version: {
    "x86_64-linux" = {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
      hash = "sha256-rYxAOGgjEP7/LZS3z3C3XodsV+TkDl3p3VbdSozHFfY=";
    };
    "aarch64-linux" = {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-arm64.AppImage";
      hash = "sha256-zOMZlg0vUjgZnmHoiZTs3QmvC37vXWW39obhTxn41+o=";
    };
  };
in
  appimageTools.wrapType2 rec {
    pname = "helium";
    version = "0.7.3.1";
    src = fetchurl (sourcesMap version).${system};

    extraInstallCommands = let
      contents = appimageTools.extract {inherit pname version src;};
    in ''
      mkdir -p "$out/share/applications"
      cp "${contents}/helium.desktop" "$out/share/applications/"
      cp -r ${contents}/usr/share/* "$out/share"

      substituteInPlace $out/share/applications/helium.desktop --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    '';
  }
