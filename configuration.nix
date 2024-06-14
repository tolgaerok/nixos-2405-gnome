# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’)....

# Tolga Erok
# 10-6-2024
# My personal NIXOS 24-05 GNOME configuration....
#
#              ¯\_(ツ)_/¯
#   ███▄    █     ██▓   ▒██   ██▒    ▒█████       ██████
#   ██ ▀█   █    ▓██▒   ▒▒ █ █ ▒░   ▒██▒  ██▒   ▒██    ▒
#  ▓██  ▀█ ██▒   ▒██▒   ░░  █   ░   ▒██░  ██▒   ░ ▓██▄
#  ▓██▒  ▐▌██▒   ░██░    ░ █ █ ▒    ▒██   ██░     ▒   ██▒
#  ▒██░   ▓██░   ░██░   ▒██▒ ▒██▒   ░ ████▓▒░   ▒██████▒▒
#  ░ ▒░   ▒ ▒    ░▓     ▒▒ ░ ░▓ ░   ░ ▒░▒░▒░    ▒ ▒▓▒ ▒ ░
#  ░ ░░   ░ ▒░    ▒ ░   ░░   ░▒ ░     ░ ▒ ▒░    ░ ░▒  ░ ░
#     ░   ░ ░     ▒ ░    ░    ░     ░ ░ ░ ▒     ░  ░  ░
#           ░     ░      ░    ░         ░ ░           ░

#-------------- Hewlett-Packard HP EliteBook Folio 9470m ------------------
#------------------ Intel® Core™ i7-3667U × 4 8GB  ------------------------
#---------------- Intel® HD Graphics 4000 (IVB GT2) ----------------------

{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let

  country = "Australia/Perth";
  hostname = "Folio-Nixos";
  kernel = pkgs.linuxPackages_zen;
  locale = "en_AU.UTF-8";
  name = "tolga";
in
{

  imports = [

    # ./DE/kde.nix
    # ./core

    # ./core/modules/system-tweaks/kernel-tweaks/8GB-SYSTEM/8GB-SYSTEM.nix
    # ./core/modules/system-tweaks/kernel-upgrades/latest-standard.nix
    # ./core/modules/system-tweaks/storage-tweaks/SSD/SSD-tweak.nix
    # ./user/tolga/home-network/mnt-samba.nix

    ./DE/gnome46.nix
    ./core/boot/efi/efi.nix
    ./core/gpu/intel/intel-laptop/HP-Folio-9470M/Eilite-Folio-9470M-HD-Intel-4000.nix
    ./core/modules
    ./core/packages
    ./core/programs
    ./core/services
    ./core/system
    ./hardware-configuration.nix
    ./network
  ];

  #---------------------------------------------------------------------
  # BCustom kernel selection from user
  #---------------------------------------------------------------------
  boot.kernelPackages = kernel;

  # Create custom auto start files
  system.activationScripts = {
    thank-you = {
      text = ''
        cat << EOF > /home/${name}/THANK-YOU
        Tolga Erok
        10-6-2024
        My personal NIXOS 24-05 GNOME configuration.

        Thank you for using my personal NixOS GNOME 24-05 configuration.
        I hope you will enjoy my setup as much as I do.
        If you encounter any issues, please contact me via email: kingtolga@gmail.com


        ¯\_(ツ)_/¯  Date and time of system rebuild
        --------------------------------------------
        $(date '+%a - %b %d %l:%M %p')
        EOF
      '';
    };

    megasync-start = {
      text = ''
        cat << EOF > /home/${name}/.config/autostart/megasync.desktop
        [Desktop Entry]
        Type=Application
        Version=1.0
        GenericName=File Synchronizer
        Name=MEGAsync
        Comment=Easy automated syncing between your computers and your MEGA cloud drive.
        TryExec=megasync
        Exec=megasync
        Icon=mega
        Terminal=false
        Categories=Network;System;
        StartupNotify=false
        X-GNOME-Autostart-Delay=1
        EOF
      '';
    };

    rygel-start = {
      text = ''
        cat << EOF > /home/${name}/.config/autostart/rygel-preferences.desktop
        [Desktop Entry]
        Type=Application
        Version=1.0
        GenericName=DLNA Media Server
        Name=Rygel Preferences
        Comment=Configure Rygel settings
        TryExec=rygel-preferences
        Exec=rygel-preferences
        Icon=rygel
        Terminal=false
        Categories=Network;System;
        StartupNotify=false
        X-GNOME-Autostart-Delay=1
        EOF
      '';
    };
  };
  
  # Add a file system entry for the "DLNA" directory bind mount
  fileSystems."/mnt/DLNA" = {
    device = "/home/${name}/DLNA";
    fsType = "none";
    options = [
      "bind"
      "rw"
    ]; # Read-write access
  };

  # Add a file system entry for the "MyGit" directory bind mount
  fileSystems."/mnt/MyGit" = {
    device = "/home/${name}/MyGit";
    fsType = "none";
    options = [
      "bind"
      "rw"
    ]; # Read-write access
  };

  # ----------------------------------------------
  # Services
  # -----------------------------------------------

  # -------------------------------------------------------------------
  # Disable unused serial device's at boot && extra powersave options &&
  # autosuspend USB devices && autosuspend PCI devices
  # -------------------------------------------------------------------
  services.udev.extraRules = ''
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


  #---------------------------------------------------------------------
  # Enable the OpenSSH daemon.
  #---------------------------------------------------------------------
  services.openssh.enable = true;

  #---------------------------------------------------------------------
  # Enable CUPS to print documents.
  #---------------------------------------------------------------------
  services.printing.enable = true;

  # Enable the D-Bus service, which is a message bus system that allows
  # communication between applications.
  # Thanks Chris Titus!
  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [

        dconf
        gcr
        udisks2
      ];
    };
  };

  services = {
    envfs = {
      enable = true;
    };
  };

  services.flatpak.enable = true;

  services.timesyncd.enable = true;
  # services.docker.enable = true;

  #----------------------------------------------------------------------
  # SystemD settings
  #----------------------------------------------------------------------
  systemd = {
    services = {

      # Mount to show in nautilus or else it will remain invisible
      bind-mount-DLNA = {
        description = "Bind mount /home/${name}/DLNA to /mnt/DLNA";
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.util-linux}/bin/mount --bind /home/${name}/DLNA /mnt/DLNA";
          RemainAfterExit = true;
        };
        wantedBy = [ "multi-user.target" ];
      };

      # Mount to show in nautilus or else it will remain invisible
      bind-mount-MyGit = {
        description = "Bind mount /home/${name}/DLNA to /mnt/MyGit";
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.util-linux}/bin/mount --bind /home/${name}/MyGit /mnt/MyGit";
          RemainAfterExit = true;
        };
        wantedBy = [ "multi-user.target" ];
      };

      # Mount to show in nautilus or else it will remain invisible
      chown-universal-directory = {
        description = "Ensure correct ownership of /Universal";
        after = [
          "local-fs.target"
          "nss-user-lookup.target"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash -c 'if id -u ${name} >/dev/null 2>&1 && id -g ${name} >/dev/null 2>&1; then mkdir -p /Universal && chown ${name}:${name} /Universal; fi'";
          RemainAfterExit = true;
        };
      };

      # Custom I/O scheduler
      "io-scheduler" = {
        description = "Set I/O Scheduler on boot - Tolga Erok";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash -c 'echo -e \"Configuring I/O Scheduler to: \"; echo \"none\" | ${pkgs.coreutils}/bin/tee /sys/block/sda/queue/scheduler; printf \"I/O Scheduler has been set to ==>  \"; cat /sys/block/sda/queue/scheduler; echo \"\"'";
        };
        enable = true;
      };

      # Create missing home dir's and more
      check-create-user-home-dirs = {
        description = "Ensure user home directories are created and owned by the user";
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            ${pkgs.bash}/bin/bash -c 'if id -u ${name} >/dev/null 2>&1 && id -g ${name} >/dev/null 2>&1; then \
              for dir in Documents Downloads Music Pictures Videos MyGit DLNA Applications; do \
                mkdir -p /home/${name}/$dir && chown ${name}:${name} /home/${name}/$dir; \
              done; \
            fi'
          '';
        };
        enable = true;
      };

      # Disable automatic startup for NetworkManager wait, systemd udev settle, and virtual terminals on tty1
      # Basically, Disable specific systemd services
      "NetworkManager-wait-online".enable = false;  # Disable the NetworkManager-wait-online service
      "systemd-udev-settle".enable = false;         # Disable the systemd-udev-settle service
      "getty@tty1".enable = false;                  # Disable the getty@tty1 service
      "autovt@tty1".enable = false;                 # Disable the autovt@tty1 service
    };

    # Define rules for managing directories, permissions, and file removal in system temporary directories
    tmpfiles.rules = [
      "d /Universal 0755 ${name} ${name} -"   # Create /Universal with 0755 permissions, owned by ${name} user and group
      "D! /tmp 1777 root root 0"              # Create /tmp with 1777 permissions, owned by root user and group, and clear it at boot
      "d /var/spool/samba 1777 root root -"   # Create /var/spool/samba with 1777 permissions, owned by root user and group
      "r! /tmp/**/*"                          # Recursively remove all files and directories in /tmp
    ];

    # For log keeping of erros
    coredump.enable = true;

    # Define resource limits and OOM handling for the nix-daemon process group
    slices."nix-daemon".sliceConfig = {

      # Define resource limits and management settings for systemd services
      MemoryHigh = "2G";                        # Set the high memory limit to 2GB
      MemoryMax = "3G";                         # Set the maximum memory limit to 3GB
      CPUQuota = "50%";                         # Limit the CPU usage to 50%
      ManagedOOMMemoryPressure = "kill";        # Configure OOM management to kill the service under high memory pressure
      ManagedOOMMemoryPressureLimit = "95%";    # Trigger OOM management when memory pressure reaches 95%
    };

    # Associate nix-daemon systemd service with resource constraints and OOM settings
    services."nix-daemon".serviceConfig = {

      # Define slice and OOM score adjustment for systemd services
      Slice = "nix-daemon.slice";  # Assign the service to the nix-daemon.slice
      OOMScoreAdjust = 1000;       # Set the OOM (Out of Memory) score adjustment to 1000
    };
  };

  #---------------------------------------------------------------------
  # System optimisations
  #---------------------------------------------------------------------
  nix = {
    settings = {
      allowed-users = [
        "@wheel"
        "${name}"
      ];
      auto-optimise-store = true;

      experimental-features = [
        "flakes"
        "nix-command"
        "repl-flake"
      ];
      cores = 0;
      sandbox = "relaxed";

      trusted-users = [
        "${name}"
        "@wheel"
        "root"
      ];

      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = false;
      tarball-ttl = 300;

      trusted-substituters = [ "http://cache.nixos.org" ];
      substituters = [ "http://cache.nixos.org" ];
    };

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedPriority = 7;

    gc = {
      automatic = true;
      dates = "weekly";
      randomizedDelaySec = "14m";
      options = "--delete-older-than 10d";
    };
  };

  #---------------------------------------------------------------------
  # MISC settings
  #---------------------------------------------------------------------
  nixpkgs.config.joypixels.acceptLicense = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  #---------------------------------------------------------------------
  # Ozone-Wayland backend when running in a Wayland session. 
  # This improves performance and compatibility, making your experience 
  # smoother and more integrated with the Wayland compositor you are using.
  #---------------------------------------------------------------------
  environment.sessionVariables = {
    # XDG_CURRENT_DESKTOP = "wayland";      # Sets the current desktop environment to Wayland.
    CLUTTER_BACKEND = "wayland"; # Specifies Wayland as the backend for Clutter.
    MOZ_ENABLE_WAYLAND = "1"; # Enables Wayland support in Mozilla applications (e.g., Firefox).
    NIXOS_OZONE_WL = "1"; # Enables the Ozone Wayland backend for Chromium-based browsers.
    NIXPKGS_ALLOW_UNFREE = "1"; # Allows the installation of packages with unfree licenses in Nixpkgs.
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Disables window decorations in Qt applications when using Wayland.
    SDL_VIDEODRIVER = "wayland"; # Sets the video driver for SDL applications to Wayland.
    XDG_SESSION_TYPE = "wayland"; # Defines the session type as Wayland.
  };

  #---------------------------------------------------------------------
  # Allow unfree packages
  #---------------------------------------------------------------------  
  nixpkgs.config.allowUnfree = true;

  # -----------------------------------------------
  # Enables simultaneous use of processor threads.
  # -----------------------------------------------
  security.allowSimultaneousMultithreading = true;

  #---------------------------------------------------------------------
  # Networking
  #---------------------------------------------------------------------
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;

    connectionConfig = {
      "ethernet.mtu" = 1462;
      "wifi.mtu" = 1462;
    };
  };

  # Define your hostname.
  networking.hostName = "${hostname}";

  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;   

  #---------------------------------------------------------------------
  # Power management & Analyze power consumption on Intel-based laptops
  #---------------------------------------------------------------------  
  hardware.bluetooth.powerOnBoot = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # --------------------------------------------------------------------
  # Permit Insecure Packages
  # --------------------------------------------------------------------
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u"
    "openssl-1.1.1v"
    "electron-12.2.3"
  ];

  # -----------------------------------------------
  # Locale settings
  # -----------------------------------------------

  # Set your time zone.
  time.timeZone = "${country}";

  # Select internationalisation properties.
  i18n.defaultLocale = "${locale}";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${locale}";
    LC_IDENTIFICATION = "${locale}";
    LC_MEASUREMENT = "${locale}";
    LC_MONETARY = "${locale}";
    LC_NAME = "${locale}";
    LC_NUMERIC = "${locale}";
    LC_PAPER = "${locale}";
    LC_TELEPHONE = "${locale}";
    LC_TIME = "${locale}";
  };

  #---------------------------------------------------------------------
  # User account settings
  #---------------------------------------------------------------------

  # Add user into user groups
  users.groups.${name} = {
    members = [ ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${name}" = {
    isNormalUser = true;
    description = "${name}";
    extraGroups = [
      "${name}"
      "adbusers"
      # "rygel"
      "audio"
      "corectrl"
      "disk"
      "docker"
      "input"
      "libvirtd"
      "lp"
      "minidlna"
      "mongodb"
      "mysql"
      "network"
      "networkmanager"
      "postgres"
      "power"
      "samba"
      "scanner"
      "smb"
      "sound"
      "storage"
      "systemd-journal"
      "udev"
      "users"
      "video"
      "wheel" # Enable ‘sudo’ for the user.
      "code"
    ];

    packages = with pkgs; [

      # INternet related
      # caprine-bin.
      firefox

      # Personal
      #docker
      #notify-send
      clementine
      ethtool
      gimp-with-plugins
      git
      git
      git-up
      kate
      libnotify
      libwps
      lolcat
      mesa
      neofetch
      notify
      notify-desktop
      wpsoffice
      variety

      # Gnome related / extentions
      # gnomeExtensions.forge
      #gnomeExtensions.blur-my-shell
      gnome-extension-manager
      gnome.dconf-editor
      gnome.gnome-disk-utility
      gnome.gnome-tweaks
      gnomeExtensions.dash-to-dock
      gnomeExtensions.logo-menu

      # Development 
      direnv
      nixfmt-rfc-style
      vscode
      vscode-extensions.brettm12345.nixfmt-vscode

      # MegaSync related
      #gnomeExtensions.mock-tray
      megasync

      # Intel related
      intel-gmmlib
      intel-media-driver
      intel-vaapi-driver
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGg5V+YAm36cZcZBZz1fv7+0kP05DpoGs1EhcrlI09i kingtolga@gmail.com"
    ];

    openssh.authorizedKeys.keyFiles = [
      #/home/tolga/.ssh/id_rsa.pub
      /home/tolga/.ssh/id_ed25519.pub
    ];
  };

  #---------------------------------------------------------------------
  # Audio settings
  #---------------------------------------------------------------------

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.

  ###################################################################################################
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.

  programs.mtr.enable = true;

  #programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  #---------------------------------------------------------------------
  # Automatic system upgrades, automatically reboot after an upgrade if
  # necessary
  #---------------------------------------------------------------------
  # system.autoUpgrade.allowReboot = true;  # Very annoying .
  system.autoUpgrade.enable = true;
  system.copySystemConfiguration = true;
  system.stateVersion = "23.05";
  #systemd.extraConfig = "DefaultTimeoutStopSec=10s";   
}
