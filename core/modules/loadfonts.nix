{ config, pkgs, ... }:

{

  fonts.packages = with pkgs; [
    # (callPackage ./apple-fonts.nix { })
    (callPackage ./testfonts.nix { })
];
}
