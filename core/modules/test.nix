{ config, pkgs, ... }:
# my custom fonts

let
  # Fetch Apple San Francisco and New York fonts..
  apple-san-francisco-new-york = pkgs.fetchzip {
    url = "https://github.com/tolgaerok/Apple-Fonts-San-Francisco-New-York/archive/refs/heads/master.zip";
    sha256 = "02imcxnzhmpvhchxmgpfx4af806p7kwx306fspk14s9g1zx7af9z";
    stripRoot = true;
  };

  # Create a derivation for the Apple fonts
  apple-fonts = pkgs.stdenv.mkDerivation {
    name = "Apple-New-York";
    src = apple-san-francisco-new-york;
    buildInputs = [ ];

    buildCommand = ''
      mkdir -p $out/share/fonts
      cp -R $src $out/share/fonts/apple/
    '';
  };

  # Fetch WPS fonts
  myfontFiles = pkgs.fetchzip {
    url = "https://github.com/tolgaerok/fonts-tolga/raw/main/WPS-FONTS.zip";
    sha256 = "02imcxnzhmpvhchxmgpfx4af806p7kwx306fspk14s9g1zx7af9z";
    stripRoot = true;
  };

  # Create a derivation for the WPS fonts
  myfonts = pkgs.stdenv.mkDerivation {
    name = "Additional WPS Fonts";
    src = myfontFiles;
    buildInputs = [ ];

    buildCommand = ''
      mkdir -p $out/share/fonts
      cp -R $src $out/share/fonts/wps/
    '';
  };
in
{

  # Fonts
  fonts.packages = with pkgs; [
    apple-fonts # Apple fonts
    myfonts # WPS fonts
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    proggyfonts
    corefonts
    font-awesome
  ];

  # The Nix User Repositories (NUR) is a community-driven collection of packages
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    }) { inherit pkgs; };
  };

  environment.systemPackages = with pkgs; [ nur.repos.sagikazarmark.sf-pro ];
}
