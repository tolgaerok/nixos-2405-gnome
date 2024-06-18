{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [

    # Intialise tmpfs parameters.
    ../tmpfs/tmpfs.nix
  ];

  #---------------------------------------------------------------------
  # Bootloader - EFI
  #---------------------------------------------------------------------
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;      # Enables the ability to modify EFI variables.
      systemd-boot.consoleMode = "max";     # Sets the console mode to the highest resolution supported by the firmware.
      systemd-boot.enable = true;           # Activates the systemd-boot bootloader.
      systemd-boot.memtest86.enable = true; # Enables the MemTest86+ option in the systemd-boot menu.
    };
    
    kernelParams = [ 
      "loglevel=3"      
      "quiet"
      "rd.systemd.show_status=false" 
      "rd.udev.log_level=3"
      "splash"
      # "systemd.show_status=auto"
      "udev.log_level=3"
      "vt.global_cursor_default=0"
    ];	

    plymouth = {
      enable = true;    # Activates the Plymouth boot splash screen.
      theme = "breeze"; # Sets the Plymouth theme to "breeze."
    };
  };
}