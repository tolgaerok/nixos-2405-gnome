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

    # Enables systemd services in the initial ramdisk (initrd).
    initrd = {
      systemd.enable = true;    # Enables systemd in the initrd for a modern boot process
      verbose = false;          # Silent boot, change to true if you want detailed boot messages
      availableKernelModules = [
        "ahci"                  # For SATA devices, likely needed
        "battery"               # For battery management, likely needed for a laptop
        "i915"                  # For Intel integrated graphics, likely needed
        "nvme"                  # For NVMe SSDs, check your hardware
        "rtsx_pci_sdmmc"        # For Realtek card reader, check your hardware
        "sd_mod"                # For SCSI disk devices, likely needed
        "usb_storage"           # For USB storage devices, likely needed
        "xhci_pci"              # For USB 3.0 controllers, likely needed
        ];
      };    
    
    plymouth = {
      enable = true;           # Activates the Plymouth boot splash screen.
      theme = "breeze";        # Sets the Plymouth theme to "breeze."
    };

    extraModprobeConfig = lib.mkMerge [
      "options i915 enable_dc=4 enable_fbc=1 enable_guc=2 enable_psr=1 disable_power_well=1"    # Configuration for Intel integrated graphics.
      "options iwlmvm power_scheme=3"                               # Sets a power-saving scheme for Intel Wi-Fi drivers.
      "options iwlwifi power_save=1 uapsd_disable=1 power_level=5"  # Manages power-saving features for Intel Wi-Fi drivers.
      "options snd_hda_intel power_save=1 power_save_controller=Y"  # Configures power-saving for Intel High Definition Audio (HDA) hardware.
    ];

    kernelParams = [
      # "elevator=none"   # Change to kyber, mq-dealine or none scheduler
      "mitigations=off" # Disables certain security mitigations, potentially improving performance but reducing security.
      "quiet"           # Suppresses verbose kernel messages during boot, providing a quieter boot process.
    ];
  };  
}
