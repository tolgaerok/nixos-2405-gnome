{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

#---------------------------------------------------------------------
# Works Well on various Intel Mesa HD GPU
#---------------------------------------------------------------------

{
  #---------------------------------------------------------------------
  # Extra laptop packages
  #---------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    acpi
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
    # auto-cpufreq.enable = false;
    # kmscon.enable = false;
    # kmscon.hwRender = true;
    acpid.enable = true;
    fwupd.enable = true;
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    upower.enable = true;

    xserver = {
      videoDrivers = [ "modesetting" ]; # Use the dedicated Intel driver
      exportConfiguration = true;
    };
  };

  #---------------------------------------------------------------------
  # Update microcode when available
  #---------------------------------------------------------------------
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  #---------------------------------------------------------------------
  # Hardware video acceleration and compatibility for Intel GPUs
  #---------------------------------------------------------------------
  hardware.opengl = {
    enable = true;
    driSupport = lib.mkDefault true;
    driSupport32Bit = lib.mkDefault true;
    extraPackages = with pkgs; [
      intel-gmmlib
      intel-media-driver # hardware decode/encode of video streams
      libvdpau-va-gl # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      vulkan-validation-layers
    ];
  };

  #---------------------------------------------------------------------
  # Power management & Analyze power consumption on Intel-based laptops
  #---------------------------------------------------------------------  
  # hardware.bluetooth.powerOnBoot = false;
  networking.networkmanager.wifi.powersave = true;

  #---------------------------------------------------------------------
  # Enable power management (do not disable this unless you have a reason to).
  # Likely to cause problems on laptops and with screen tearing if disabled.
  #---------------------------------------------------------------------
  powerManagement = {
    enable = true;
    powertop = {
      enable = lib.mkForce true;
    };
  };

  # Allow brightness control by video group.
  hardware.acpilight.enable = true;

  #-----------------------------------------------------------------------
  # Enable TLP for better power management with Schedutil governor
  #---------------------------------------------------------------------
  services.tlp = {
    enable = true;
    settings = {
      DISK_DEVICES = "nvme0n1 nvme1n1 sda sdb"; # DISK_DEVICES must be specified for AHCI_RUNTIME_PM settings to work right.
      AHCI_RUNTIME_PM_ON_AC = "on"; # with AHCI_RUNTIME_PM_ON_AC/BAT set to defaults in battery mode, P51
      AHCI_RUNTIME_PM_ON_BAT = "auto"; # can't resume from sleep and P50 can't go to sleep.

      # with RUNTIME_PM_ON_BAT/AC set to defaults, P50/P51 can't go to sleep
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      #CPU_BOOST_ON_AC = 1;
      #CPU_BOOST_ON_BAT = 0;

      #CPU_ENERGY_PERF_POLICY_ON_AC = "ondemand";
      #CPU_ENERGY_PERF_POLICY_ON_BAT = "ondemand";

      #CPU_MAX_PERF_ON_AC = 99;
      #CPU_MAX_PERF_ON_BAT = 75;
      #CPU_MIN_PERF_ON_BAT = 75;

      #CPU_SCALING_GOVERNOR_ON_AC = "performance"; # Adjust as needed
      #CPU_SCALING_GOVERNOR_ON_BAT = "powersave"; # Adjust as needed

      NATACPI_ENABLE = 1;

      #RUNTIME_PM_ON_AC = "on";
      #RUNTIME_PM_ON_BAT = "auto"; # or auto

      #SCHED_POWERSAVE_ON_BAT = 1;

      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;

      #START_CHARGE_THRESH_BAT0 = 40;
      #STOP_CHARGE_THRESH_BAT0 = 80;

      TPACPI_ENABLE = 1;
      TPSMAPI_ENABLE = 1;

      WOL_DISABLE = "Y";
    };
  };
}
