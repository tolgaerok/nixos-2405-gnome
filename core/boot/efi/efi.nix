{ config, pkgs, lib, ... }:
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
      efi.canTouchEfiVariables = true;  # Enables the ability to modify EFI variables.
      systemd-boot.enable = true;       # Activates the systemd-boot bootloader.
      systemd-boot.consoleMode = "max";
    };

    initrd.systemd.enable = true;     # Enables systemd services in the initial ramdisk (initrd).
    initrd.verbose = false;           # silent boot
    plymouth.enable = true;           # Activates the Plymouth boot splash screen.
    plymouth.theme = "breeze";        # Sets the Plymouth theme to "breeze."

    extraModprobeConfig = lib.mkMerge [
    "options i915 enable_dc=4 enable_fbc=1 enable_guc=2 enable_psr=1 disable_power_well=1"    # Configuration for Intel integrated graphics.
    "options iwlmvm power_scheme=3"                               # Sets a power-saving scheme for Intel Wi-Fi drivers.
    "options iwlwifi power_save=1 uapsd_disable=1 power_level=5"  # Manages power-saving features for Intel Wi-Fi drivers.
    "options snd_hda_intel power_save=1 power_save_controller=Y"  # Configures power-saving for Intel High Definition Audio (HDA) hardware.
  ];

  kernelParams = [
    "elevator=none"   # Change to kyber, mq-dealine or none scheduler
    "mitigations=off" # Disables certain security mitigations, potentially improving performance but reducing security.
    "quiet"           # Suppresses verbose kernel messages during boot, providing a quieter boot process.
  ];
  };
  
}
