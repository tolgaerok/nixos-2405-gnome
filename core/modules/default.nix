{ ... }:

{

  #---------------------------------------------------------------------
  # Various modules outside of nixos, custom additions
  #---------------------------------------------------------------------

  imports = [
    
    # ./basic-fonts.nix
    # ./loadfonts.nix         # install from my github
    # ./testfonts.nix
    ./appimage-registration # Credits to Brian Francisco
    ./custom-pkgs           # personal coded scriptBin's
    ./iphone/iphone.nix
    ./my-fonts
    ./openRGB
    ./security
    ./smart-drv-mon
    ./vm
  ];
}
