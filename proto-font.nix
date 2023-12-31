{ pkgs, lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "proto-font";
  version = "1.401";

  src = fetchurl {
    url =
      "https://github.com/0xType/0xProto/releases/download/${version}/0xProto-Regular.ttf";
    hash = "sha256-RSeVE7OnkMq3weAdFLZzZIDgi4r19SFD7QdXCOYWOIo=";
  };

  dontUnpack = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher --quiet --variable-width-glyphs --complete --careful --out $out/share/fonts/proto ${src}

    runHook postInstall
  '';

  meta = with lib; {
    description = "0xProto: an opinionated font for software engineers";
    longDescription = "";
    homepage = "https://github.com/0xType/0xProto";
    license = licenses.free;
    platforms = platforms.all;
  };
}
