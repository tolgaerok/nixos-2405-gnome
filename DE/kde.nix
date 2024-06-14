{ config, pkgs, ... }:

{



# New configuration
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;


}
