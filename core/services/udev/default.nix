{
  config,
  pkgs,
  lib,
  ...
}:

{
  #---------------------------------------------------------------------
  # Dynamic device management. udev is responsible for device detection, 
  # device node creation, and managing device events.
  #---------------------------------------------------------------------

  # -------------------------------------------------------------------
  # Disable unused serial device's at boot && extra powersave options &&
  # autosuspend USB devices && autosuspend PCI devices
  # -------------------------------------------------------------------

  services = {
    udev = {
      enable = true;

      # enable high precision timers if they exist && set I/O scheduler to NONE for ssd/nvme
      # autosuspend USB devices && autosuspend PCI devices
      # (https://gentoostudio.org/?page_id=420) 
      extraRules = ''
        # Disable Ethernet Wake-on-LAN
        ACTION=="add", SUBSYSTEM=="net", NAME=="enp*", RUN+="${pkgs.ethtool}/sbin/ethtool -s \$name wol d"

        # Disable serial ports ttyS1 to ttyS3
        KERNEL=="ttyS[1-3]", SUBSYSTEM=="tty", ACTION=="add", ATTR{enabled}="0"

        # Autosuspend PCI devices
        ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"

        # Autosuspend USB devices
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"

        # Set scheduler to 'none' for certain block devices with ext4 filesystem
        ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="ext4", ATTR{../queue/scheduler}="none"

        # Set group for hpet to 'audio'
        KERNEL=="hpet", GROUP="audio"

        # Set group for rtc0 to 'audio'
        KERNEL=="rtc0", GROUP="audio"
      '';
    };
  };
}
