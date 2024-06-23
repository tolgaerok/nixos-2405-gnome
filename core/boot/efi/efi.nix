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
      "elevator=kyber"           # Change IO scheduler to Kyber
      "io_delay=none"            # Disable I/O delay accounting
      "iomem=relaxed"            # Allow more relaxed I/O memory access
      "irqaffinity=0-3"          # Set IRQ affinity to CPUs 0-3 (Intel Core i7-3667U specific)
      "loglevel=3"               # Set kernel log level to 3 (default)
      "mitigations=off"          # Disable CPU mitigations for security vulnerabilities
      "noirqdebug"               # Disable IRQ debugging
      "pti=off"                  # Disable Kernel Page Table Isolation (PTI)
      "quiet"                    # Suppress verbose kernel messages during boot
      "rd.systemd.show_status=false"  # Disable systemd boot status display
      "rd.udev.log_level=3"      # Set udev logging level to 3
      "rootdelay=0"              # No delay when mounting root filesystem
      "splash"                   # Enable graphical boot splash screen
      "threadirqs"               # Enable threaded interrupt handling
      "udev.log_level=3"         # Set udev logging level to 3
      "vt.global_cursor_default=0"  # Disable blinking cursor in text mode
      # "systemd.show_status=auto"   # Commented out, not used in this configuration
    ];

    # plymouth
    plymouth = {
      enable = true;
      theme = "breeze";
    };
  };
}
