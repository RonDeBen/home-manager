{ pkgs, lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "monaspace-font";
  version = "v1.000";

  src = fetchzip {
    url =
      "https://github.com/githubnext/monaspace/releases/download/${version}/monaspace-${version}.zip";
    stripRoot = false;
    hash = "sha256-H8NOS+pVkrY9DofuJhPR2OlzkF4fMdmP2zfDBfrk83A=";

  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    d="./monaspace-${version}/fonts/otf/*.otf"

    install -Dm644 $d -t $out/share/fonts/monaspace
    regular="./monaspace-${version}/fonts/otf/*-Regular.otf"

    for font in $regular; do
    	echo "Installing is $font  ..."
    	${pkgs.nerd-font-patcher}/bin/nerd-font-patcher --quiet --variable-width-glyphs --complete --careful --out $out/share/fonts/monaspace "$font"
    done

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
