{ config, pkgs, ... }:

let

  installMyFontsScript = ''
    mkdir -p $out/share/fonts
    wget -q https://github.com/tolgaerok/apple-fonts/archive/refs/heads/main.zip
    wget -q https://github.com/tolgaerok/fonts-tolga/raw/main/WPS-FONTS.zip
    unzip -o main.zip -d $out/share/fonts
    unzip -o WPS-FONTS.zip -d $out/share/fonts
    fc-cache -f -v
    rm main.zip
    rm WPS-FONTS.zip
  '';

  installMyFonts = pkgs.writeScriptBin "install-my-fonts" installMyFontsScript;

  # Create custom varible to house my WPS fonts!
  myfontFiles = pkgs.fetchzip {
    url = "https://github.com/tolgaerok/fonts-tolga/raw/main/WPS-FONTS.zip";
    sha256 = "02imcxnzhmpvhchxmgpfx4af806p7kwx306fspk14s9g1zx7af9z";
    stripRoot = false;
  };

  # myfonts will be the WPS fonts
  myfonts = pkgs.stdenv.mkDerivation {
    name = "Additional WPS Fonts";
    src = myfontFiles;
    buildInputs = [ ];

    # mkdir will be: /nix/store/xxxxxxx-Additional-WPS-Fonts
    buildCommand = ''
      mkdir -p $out/share/fonts
      cp -R $src $out/share/fonts
    '';
  };
in
{
  imports = [
    # ./apple-fonts.nix
  ];

  # Fonts
  fonts.packages = with pkgs; [
    myfonts # my additional WPS fonts
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    proggyfonts
    # nerdfonts
    corefonts
    font-awesome
  ];

  # The Nix User Repositories (NUR) is a community-driven collection of packages
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    }) { inherit pkgs; };
  };

  environment.systemPackages = with pkgs; [
    nur.repos.sagikazarmark.sf-pro
    wget
    unzip
    fontconfig
    installMyFonts  # Apple && WPS from my repo
  ];
}

# notes: to find out your sha256
# nix-prefetch-url --unpack https://github.com/tolgaerok/fonts-tolga/raw/main/WPS-FONTS.zip
# path is '/nix/store/jywgj34lbk28llp6mb2xfwzc81drkf8z-WPS-FONTS.zip'
# sha256 = 02imcxnzhmpvhchxmgpfx4af806p7kwx306fspk14s9g1zx7af9z

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
