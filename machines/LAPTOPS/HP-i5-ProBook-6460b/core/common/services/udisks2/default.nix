{ config, pkgs, lib, ... }:

#---------------------------------------------------------------------
# Automatically detect and manage storage devices connected to your 
# system. This includes handling device mounting and unmounting, 
# as well as providing a consistent interface for accessing USB and 
# managing disk-related operations.
#---------------------------------------------------------------------

# services.devmon.enable = true;
# services.udisks2.enable = true;

{
  services = {
    udisks2 = {
      enable = true;
    };

    devmon = {
      enable = true;
    };
  };
}
