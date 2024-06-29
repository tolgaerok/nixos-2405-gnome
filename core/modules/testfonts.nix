{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "apple-fonts";
  version = "1.0-stable-29-jun-2024";

  src = fetchFromGitHub {
    owner = "tolgaerok";
    repo = "apple-fonts";
    rev = "fd93227bf50a81a025a406952e388348fae707f1"; # Updated commit hash
    hash = "sha256-IBnV/+9QITFSLePuQ/XkFjiGfH5tTnQFSMKvUL8t4Ms="; # Updated sha256 hash
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/{opentype,truetype}

    find . -name "*.otf" -type f -exec install -Dm644 {} -t "$out/share/fonts/opentype" \;
    find . -name "*.ttf" -type f -exec install -Dm644 {} -t "$out/share/fonts/truetype" \;

    runHook postInstall
  '';
}
