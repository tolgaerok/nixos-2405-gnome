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

    plymouth = {
      enable = true;    # Activates the Plymouth boot splash screen.
      theme = "breeze"; # Sets the Plymouth theme to "breeze."
    };
  };
}
