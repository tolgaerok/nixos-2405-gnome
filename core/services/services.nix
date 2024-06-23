# This NixOS configuration file is for setting up various services and printer drivers on the system.

{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let

  #---------------------------------------------------------------------
  #   Printers and printer drivers (To suit my HP LaserJet 600 M601)
  #---------------------------------------------------------------------
  # List of printer drivers to be installed
  printerDrivers = [
    pkgs.brgenml1cupswrapper  # Generic drivers for more Brother printers
    pkgs.brgenml1lpr          # Generic drivers for more Brother printers
    pkgs.brlaser              # Drivers for some Brother printers
    pkgs.cnijfilter2          # Generic Canon printer drivers
    pkgs.gutenprint           # Drivers for many different printers from many different vendors
    pkgs.gutenprintBin        # Additional, binary-only drivers for some printers
    pkgs.hplip                # Drivers for HP printers
    pkgs.hplipWithPlugin      # HP printer drivers with proprietary plugin
  ];
in

{
  imports = [
    ./samba 
  ];

  # ----------------------------------------------
  # Services
  # ----------------------------------------------   
  services = {

    # Enable GEO location
    geoclue2 = { 
      enable = true;
    };
    
    # Enable and configure NextDNS service
    nextdns = {
      enable = true;
      arguments = ["-config" "nixfolio-48b246.dns.nextdns.io"];
    };    

    # Timesyncd: Synchronizes system time with network time servers
    timesyncd.enable = true;

    # GVFS: GNOME Virtual File System support
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome3.gvfs;
    };

    # PipeWire: Manages audio and media
    pipewire = {
      enable = true;            
      alsa.enable = true;       # Enable ALSA backend for PipeWire
      alsa.support32Bit = true; # Enable 32-bit ALSA support
      pulse.enable = true;      # Enable PulseAudio compatibility layer for PipeWire
    };

    # Udev: Device management and custom rules
    udev = {
      enable = true; # Enable udev for device management

      # Extra udev rules for various hardware configurations
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
        ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="ext4", ATTR{../queue/scheduler}="kyber"

        # Set group for hpet to 'audio'
        KERNEL=="hpet", GROUP="audio"

        # Set group for rtc0 to 'audio'
        KERNEL=="rtc0", GROUP="audio"
      '';
    };

    # Udisks2: Disk management service
    udisks2 = {
      enable = true; 
    };

    # Devmon: Automount removable media
    devmon = {
      enable = true;    # Enable devmon for automounting removable media
    };

    # Avahi: Network service discovery
    avahi = {
      enable = true;        # Enable Avahi for network service discovery
      nssmdns4 = true;      # Enable mDNS for name resolution
      openFirewall = true;  # Open firewall ports for Avahi

      publish = {
        addresses = true;     # Publish IP addresses
        domain = true;        # Publish domain name
        enable = true;        # Enable Avahi publishing
        hinfo = true;         # Publish host information
        userServices = true;  # Publish user services
        workstation = true;   # Publish workstation type
      };

      extraServiceFiles = {
        smb = ''
          <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
          <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
          <service-group>
            <name replace-wildcards="yes">%h</name>
            <service>
              <type>_smb._tcp</type>
              <port>445</port>
            </service>
          </service-group>
        '';
      };
    };

    # Blueman: Bluetooth management tool
    blueman.enable = true;      # Enable Blueman for Bluetooth management

    # D-Bus: Message bus system
    dbus = {
      enable = true;            # Enable D-Bus message bus system
      packages = with pkgs; [
        dconf                   # Dconf editor for GNOME settings
        gcr                     # GNOME keyring
        udisks2                 # Disk management service
      ];
    };

    # Hardware: Configuration for various hardware services
    hardware = {
      bolt.enable = true;       # Enable Bolt for Thunderbolt device management
      # firmware.enable = true; # Enable firmware updates (commented out)
    };

    # Earlyoom: Early OOM (Out Of Memory) killer service
    earlyoom = {
      enable = true;    # Enable the early OOM killer service

      # Free Memory Threshold
      # Sets the point at which earlyoom will intervene to free up memory.
      # When free memory falls below 15%, earlyoom acts to prevent system slowdown or freezing.
      freeMemThreshold = 15;

      # Technical Explanation:
      # The earlyoom service monitors system memory and intervenes when free memory drops below the specified threshold.
      # It helps prevent system slowdowns and freezes by intelligently killing less important processes to free up memory.
      # In this configuration, it triggers when free memory is only 15% of total RAM.
      # Adjust the freeMemThreshold value based on your system's memory usage patterns.
    };

    # EnvFS: Encrypted filesystem support
    envfs = {
      enable = true;       # Enable EnvFS for encrypted filesystem support
    };

    # Flatpak: Sandboxed applications
    flatpak.enable = true; # Enable Flatpak for installing sandboxed applications

    # Fstrim: SSD maintenance
    fstrim = {
      enable = true;       # Enable fstrim service for SSD maintenance
    };

    # Logind: Login management settings
    logind = {
      extraConfig = ''
        # Set the maximum size of runtime directories to 100%
        RuntimeDirectorySize=100%

        # Set the maximum number of inodes in runtime directories to 1048576
        RuntimeDirectoryInodesMax=1048576
      '';
    };

    # OpenSSH: Secure shell access
    openssh = {
      enable = true;    # Enable OpenSSH server
      settings = {
        PermitRootLogin = lib.mkForce "yes";        # Allow root login
        UseDns = false;                             # Disable DNS lookup
        X11Forwarding = false;                      # Disable X11 forwarding
        PasswordAuthentication = lib.mkForce true;  # Enable password authentication
        KbdInteractiveAuthentication = true;        # Enable keyboard-interactive authentication
      };

      banner = ''
        # SSH login banner
               ⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⠛⠛⠋⠉⠈⠉⠉⠉⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿
               ⣿⣿⣿⣿⣿⡿⠋⠁   Tolga Erok ⠀⠀⠀⠀⠛⢿⣿⣿⣿⣿
               ⣿⣿⣿⣧⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ⠀⣰⣿⣿⣿
               ⣿⣿⣿⣿⡄⠈⠀⠀⠀ ¯\_(ツ)_/¯⠀  ⢀⣠⣴⣾⣿⣿⣿⣿⣿                    
               >ligma
      '';

      hostKeys = [
        {
          bits = 4096; # RSA key with 4096 bits
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }

        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519"; # ED25519 key
        }
      ];
    };

    # Power Profiles Daemon: Manages power profiles (disabled)
    power-profiles-daemon = {
      enable = false;     # Disable power profiles daemon
    };

    #---------------------------------------------------------------------
    #   Enable CUPS to print documents.
    #---------------------------------------------------------------------
    # Printing: CUPS printing service and drivers
    printing = {
      drivers = printerDrivers;   # Install printer drivers
      enable = true;              # Enable CUPS printing service
      browsing = true;
    };

    #--------------------------------------------------------------------- 
    #   Enable the SSH daemon
    #---------------------------------------------------------------------  
    sshd.enable = true;   # Enable SSH daemon (redundant with OpenSSH configuration above)

    # Thermald: Thermal management daemon (disabled)
    thermald = {
      enable = false;     # Disable thermald service
    };
  };

  # iPhone Support: Configures support for iPhone
  iphone = {
    enable = true;  # Enable iPhone support
    user = "tolga"; # Set the user for iPhone support
  };
}
