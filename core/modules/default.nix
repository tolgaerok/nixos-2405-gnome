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
    ./smart-drv-mon
    ./vm
  ];
}
