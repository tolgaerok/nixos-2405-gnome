{ config, pkgs, ... }:

let
  # Create custom varible to house my WPS fonts!
  apple-san-francisco-new-york = pkgs.fetchzip {
    url = "https://github.com/tolgaerok/Apple-Fonts-San-Francisco-New-York/archive/refs/heads/master.zip";
    sha256 = "02imcxnzhmpvhchxmgpfx4af806p7kwx306fspk14s9g1zx7af9z";
    stripRoot = false;
  };

  # myfonts will be the WPS fonts
  apple-fonts = pkgs.stdenv.mkDerivation {
    name = "Apple-New-York";
    src = apple-san-francisco-new-york;
    buildInputs = [ ];

    # mkdir will be: /nix/store/xxxxxxx-Apple-New-York
    buildCommand = ''
      mkdir -p $out/share/fonts
      cp -R $src $out/share/fonts/newyork/
    '';
  };
in
{
  # Fonts
  fonts.packages = with pkgs; [
    apple-fonts # my additional apple fonts
  ];
}

# notes: to find out your sha256
# nix-prefetch-url --unpack https://github.com/tolgaerok/Apple-Fonts-San-Francisco-New-York/archive/refs/heads/master.zip
# path is '/nix/store/lrr4c50fq6758nmq9nm1is9nn3id7h84-master.zip'
# 02imcxnzhmpvhchxmgpfx4af806p7kwx306fspk14s9g1zx7af9z

# LOCATE YOUR CUSTOM font loctation
# nix-build -E '
#  with import <nixpkgs> {}; 
#  let 
#    myfontFiles = pkgs.fetchzip { 
#      url = "https://github.com/tolgaerok/fonts-tolga/raw/main/WPS-FONTS.zip"; 
#      sha256 = "02imcxnzhmpvhchxmgpfx4af806p7kwx306fspk14s9g1zx7af9z"; 
#      stripRoot = false; 
#    }; 
#    myfonts = pkgs.stdenv.mkDerivation { 
#      name = "Additional-WPS-Fonts"; 
#      src = myfontFiles; 
#      buildInputs = [ ]; 
#      buildCommand = "
#        mkdir -p \$out/share/fonts
#        cp -R \$src/* \$out/share/fonts
#      "; 
#    }; 
#  in 
#  myfonts
# '

# OUTPUT IN TERMINAL
# this derivation will be built:
#  /nix/store/44cz2adm3p978jv5i0gbazxlqr8cwjnv-Additional-WPS-Fonts.drv
# building '/nix/store/44cz2adm3p978jv5i0gbazxlqr8cwjnv-Additional-WPS-Fonts.drv'...
# /nix/store/cx61hnrjcy11dgp8gkd0b67wgzyvbsb2-Additional-WPS-Fonts

# MY CUSTOM FONTS ARE HERE
# cd /nix/store/cx61hnrjcy11dgp8gkd0b67wgzyvbsb2-Additional-WPS-Fonts
# cd share
# cd fonts
