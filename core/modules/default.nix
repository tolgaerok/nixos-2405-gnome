{ ... }:

{

  #---------------------------------------------------------------------
  # Various modules outside of nixos, custom additions
  #---------------------------------------------------------------------

  imports = [
    # ./apple-fonts
    ./appimage-registration # Credits to Brian Francisco
    ./basic-fonts.nix
    ./custom-pkgs # personal coded scriptBin's
    ./iphone/iphone.nix
    ./openRGB
    ./smart-drv-mon
    ./vm
  ];
}
