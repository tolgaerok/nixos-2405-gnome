# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead..
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "uas" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "tcp_cubic"     # Cubic: A traditional and widely used congestion control algorithm
    "tcp_reno"      # Reno: Another widely used and stable algorithm
    "tcp_newreno"   # New Reno: An extension of the Reno algorithm with some improvements
    "tcp_bbr"       # BBR: Dynamically optimize how data is sent over a network, aiming for higher throughput and reduced latency
    "tcp_westwood"  # Westwood: Particularly effective in wireless networks
    "i915"
    ];

  boot.extraModulePackages = [ ];

  boot.kernel.sysctl = {
    "kernel.pty.max" = 24000;
    "net.core.default_qdisc" = "cake";
    "vm.dirty_background_bytes" = 268435456;
    "vm.dirty_bytes" = 536870912;
    "vm.swappiness" = 10;
    "kernel.sysrq" = 1;
    "net.ipv4.tcp_congestion_control" = "westwood";   # sets the TCP congestion control algorithm to Westwood for IPv4 in the Linux kernel.
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/990e2ba9-3811-4a26-8b76-b67eb3e771ba";
      fsType = "ext4";

    # Optimize SSD
    # ---------------------------------------------
    options = [
      "data=ordered"      # Ensures data ordering, improving file system reliability and performance by writing data to disk in a specific order.
      "defaults"          # Applies the default options for mounting, which usually include common settings for permissions, ownership, and read/write access.
      "discard"           # Enables the TRIM command, which allows the file system to notify the storage device of unused blocks, improving performance and longevity of solid-state drives (SSDs).
      # "errors=remount-ro" # Remounts the file system as read-only (ro) in case of errors to prevent further potential data corruption.
      "noatime"           # Disables updating access times for files, improving file system performance by reducing write operations.
      "nodiratime"        # Disables updating directory access time, improving file system performance by reducing unnecessary writes.
      "relatime"          # Updates the access time of files relative to the modification time, minimizing the performance impact compared to atime
    # "discard=async"     # Helps maintain the SSD's performance over time by reducing write amplification and improving block management

    ];

    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0949-DFFD";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/27fe8692-b675-485d-a12f-898c1937cad9"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s25.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
