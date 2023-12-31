{ pkgs, lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "noto-sans-nerd-font";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = "v${version}";
    sha256 =
      "1qpck8wzjy0yf41hl4rkvv17kj9zbphvw5bczvnfgv356k3pyk4s"; # Replace with the correct hash
    # Specify the path to the Noto Sans fonts within the repository
    fetchSubmodules = true; # Set to true to fetch necessary submodules
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp -r ${src}/patched-fonts/Noto/* $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Noto Sans fonts patched with Nerd Fonts";
    longDescription =
      "Noto Sans font patched with additional glyphs from Nerd Fonts, suitable for developers.";
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    license = licenses.free; # Ensure this matches the license for Noto Sans
    platforms = platforms.all;
  };
}
