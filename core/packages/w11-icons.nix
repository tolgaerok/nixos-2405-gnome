{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "win11-icon-theme";
  version = "0-unstable-2023-05-13";
  name = "win11";

  src = pkgs.fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Win11-icon-theme";
    rev = "9c69f73b00fdaadab946d0466430a94c3e53ff68";
    hash = "sha256-jN55je9BPHNZi5+t3IoJoslAzphngYFbbYIbG/d7NeU=";
  };

  nativeBuildInputs = [ pkgs.gtk3 ];

  installPhase = ''
    mkdir -p $out/share/icons

    patchShebangs install.sh
    ./install.sh -a -d $out/share/icons
  '';

  meta = with pkgs.lib; {
    description = "A colorful design icon theme for Linux desktops";
    homepage = "https://github.com/yeyushengfan258/Win11-icon-theme";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.yeyushengfan258 ];
    platforms = platforms.all;
  };
}
