{
  appimageTools,
  fetchurl,
  stdenv,
}: let
  inherit (stdenv.hostPlatform) system;

  sourcesMap = version: {
    "x86_64-linux" = {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
      hash = "sha256-JFaGuRbjNEzFOEpntbzARxCOxA/2Fxhd31nXaVPfpFg=";
    };
    "aarch64-linux" = {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-arm64.AppImage";
      hash = "sha256-0ki3xRheyKfXAjTYk8y/DWd8+mGcZ4mCF8cA6OpHah4=";
    };
  };
in
  appimageTools.wrapType2 rec {
    pname = "helium";
    version = "0.7.4.1";
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
