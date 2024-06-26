{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

with lib;

let
  cfg = config.drivers.intel;
in

#---------------------------------------------------------------------
# Works Well on various Intel Mesa HD GPUs
#---------------------------------------------------------------------

{  

  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg.enable {
    #---------------------------------------------------------------------
    # Extra laptop packages
    #---------------------------------------------------------------------
    environment.systemPackages = with pkgs; [
      acpi
      battery
      cpufrequtils
      cpupower-gui
      ethtool
      powerstat
      powertop
      tlp
    ];

    #---------------------------------------------------------------------
    # Laptop configuration
    #---------------------------------------------------------------------
    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };

    services = {
      acpid.enable = true;                  # Enable ACPI daemon for handling power events and managing power configurations
      fwupd.enable = true;                  # Enable firmware updates using fwupd, a daemon to handle firmware updates on Linux systems
      power-profiles-daemon.enable = false; # Disable the power-profiles-daemon, which manages power profiles
      thermald.enable = true;               # Enable Intel's thermal daemon for managing thermal zones and cooling policies
      upower.enable = true;                 # Enable UPower, a daemon for power management and battery monitoring

    xserver = {
      videoDrivers = [ "i915" ];     # Use the modesetting driver for X server, which is often used with Intel GPUs
      exportConfiguration = true;           # Export the X server configuration, making it available to other components
  };
};


    #---------------------------------------------------------------------
    # Update microcode when available
    #---------------------------------------------------------------------
    # hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

    #---------------------------------------------------------------------
    # Hardware video acceleration and compatibility for Intel GPUs
    #---------------------------------------------------------------------
    hardware.opengl = {
      enable = true; # Enable OpenGL support

      driSupport = mkDefault true;      # Enable Direct Rendering Infrastructure (DRI) support
      driSupport32Bit = mkDefault true; # Enable 32-bit DRI support for compatibility with 32-bit applications

    extraPackages = with pkgs; [
      intel-media-driver  # Intel media driver for hardware acceleration
      vaapiIntel          # VA-API (Video Acceleration API) driver for Intel GPUs
      vaapiVdpau          # VDPAU (Video Decode and Presentation API for Unix) backend for VA-API
      libvdpau-va-gl      # VDPAU driver that uses VA-API as backend
      intel-gmmlib        # Intel Graphics Memory Management Library
  ];
   
};

    # environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
    environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; }; # Force Intel i965 driver

    #---------------------------------------------------------------------
    # Power management & Analyze power consumption on Intel-based laptops
    #---------------------------------------------------------------------
    networking.networkmanager.wifi.powersave = true;

    #---------------------------------------------------------------------
    # Enable power management (do not disable this unless you have a reason to).
    # Likely to cause problems on laptops and with screen tearing if disabled.
    #---------------------------------------------------------------------
    powerManagement = {
      enable = true;
      powertop.enable = mkForce true;
    };

    # Allow brightness control by video group.
    hardware.acpilight.enable = true;

    #---------------------------------------------------------------------
    # Enable TLP for better power management with Schedutil governor
    #---------------------------------------------------------------------
    services.tlp = {
      enable = true; # Enable the TLP power management tool

      settings = {
        DISK_DEVICES = "nvme0n1 nvme1n1 sda sdb"; # Specify disk devices to manage
        AHCI_RUNTIME_PM_ON_AC = "on";             # Enable runtime power management for SATA disks when on AC power
        AHCI_RUNTIME_PM_ON_BAT = "auto";          # Enable automatic runtime power management for SATA disks when on battery power
        RUNTIME_PM_ON_AC = "on";                  # Enable runtime power management for PCIe devices when on AC power
        RUNTIME_PM_ON_BAT = "auto";               # Enable automatic runtime power management for PCIe devices when on battery power
        NATACPI_ENABLE = 1;                       # Enable ACPI calls for battery status and charge thresholds (1 = enabled)
        SOUND_POWER_SAVE_ON_AC = 0;               # Disable power saving for sound devices when on AC power (0 = disabled)
        SOUND_POWER_SAVE_ON_BAT = 1;              # Enable power saving for sound devices when on battery power (1 = enabled)
        TPACPI_ENABLE = 1;                        # Enable ThinkPad-specific ACPI features (1 = enabled)
        TPSMAPI_ENABLE = 1;                       # Enable ThinkPad-specific battery management via tp-smapi (1 = enabled)
        USB_AUTOSUSPEND = 1;
        WOL_DISABLE = "Y";                        # Disable Wake-on-LAN (Y = disabled)
      };
    };
  };
   

}
