{ ... }:

{

  #---------------------------------------------------------------------
  # Various modules outside of nixos, custom additions
  #---------------------------------------------------------------------

  imports = [
    # ./apple-fonts
    # ./vm
    ./appimage-registration   # Credits to Brian Francisco
    ./custom-pkgs             # personal coded scriptBin's
    ./iphone/iphone.nix
    ./openRGB
    ./smart-drv-mon
  ];
}
