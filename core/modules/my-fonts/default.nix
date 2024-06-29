{ config, pkgs, ... }:

# Does a fetchFromGitHub to DL my fonts from my repo
# https://github.com/tolgaerok/apple-fonts

{
  fonts.packages = with pkgs; [ 
    (callPackage ./my-fonts.nix { }) 
  ];
}
