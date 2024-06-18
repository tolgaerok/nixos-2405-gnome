{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
in
{
  imports = [
    # Intialise tmpfs parameters.
    ../tmpfs/tmpfs.nix
  ];

  # Various plymouth themes
  environment = {
    systemPackages = with pkgs; [ plymouth ];
  };

  #---------------------------------------------------------------------
  # Bootloader - EFI
  #---------------------------------------------------------------------
  boot = {
    loader = {
      efi.canTouchEfiVariables = true; # Enables the ability to modify EFI variables.
      grub.copyKernels = true;
      systemd-boot = {
        consoleMode = "max"; # Sets the console mode to the highest resolution supported by the firmware.
        enable = true; # Activates the systemd-boot bootloader.
        memtest86.enable = true; # Enables the MemTest86+ option in the systemd-boot menu.
      };
    };

    kernelParams = [
      "loglevel=3"
      "mitigations=off"   # Disables certain security mitigations, potentially improving performance but reducing security.
      "quiet"             # Suppresses verbose kernel messages during boot, providing a quieter boot process.
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "splash"
      "udev.log_level=3"
      "vt.global_cursor_default=0"
      # "elevator=none"   # Change to kyber, mq-deadline, or none scheduler
      # "systemd.show_status=auto"
    ];

    # plymouth
    plymouth = {
      enable = true;
      theme = "breeze";
    };
  };
}
