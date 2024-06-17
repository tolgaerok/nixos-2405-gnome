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
  username,
  ...
}:

with lib;

let
  latest-std-kernel = pkgs.linuxPackages_latest;
  latest-xanmod-kernel = pkgs.linuxPackages_xanmod_latest;
  zen-std-kernel = pkgs.linuxPackages_zen;
  
  country = "Australia/Perth";
  hostname = "Folio-Nixos";
  locale = "en_AU.UTF-8";
  name = "tolga";
in

{

  imports = [
    # ./DE/kde.nix    
    # ./core/modules/system-tweaks/kernel-tweaks/8GB-SYSTEM/8GB-SYSTEM.nix     
    # ./user/tolga/home-network/mnt-samba.nix

    ./DE/gnome46.nix
    ./core/boot/efi/efi.nix
    ./core/gpu/intel/intel-laptop/HP-Folio-9470M/Eilite-Folio-9470M-HD-Intel-4000.nix
    ./core/modules
    ./core/modules/system-tweaks/storage-tweaks/SSD/SSD-tweak.nix
    ./core/packages
    ./core/programs
    ./core/services/services.nix
    ./core/system
    ./hardware-configuration.nix
    ./network
  ];

  #---------------------------------------------------------------------
  # BCustom kernel selection from user
  #---------------------------------------------------------------------
  boot.kernelPackages = latest-std-kernel;   

  # ----------------------------------------------
  # Services
  # -----------------------------------------------   
  #services = {
  #  timesyncd.enable = true;
  #  gvfs.enable = true;
  #  pipewire = {
  #    enable = true;
  #    alsa.enable = true;
  #    alsa.support32Bit = true;
  #    pulse.enable = true;
  #  };
  #};

  #---------------------------------------------------------------------
  # Ozone-Wayland backend when running in a Wayland session. 
  # This improves performance and compatibility, making your experience 
  # smoother and more integrated with the Wayland compositor you are using.
  #---------------------------------------------------------------------
  environment.sessionVariables = {
    # XDG_CURRENT_DESKTOP = "wayland";      # Sets the current desktop environment to Wayland.
    # XDG_SESSION_TYPE = "wayland";         # Defines the session type as Wayland.

    CLUTTER_BACKEND = "wayland";                # Specifies Wayland as the backend for Clutter.
    MOZ_ENABLE_WAYLAND = "1";                   # Enables Wayland support in Mozilla applications (e.g., Firefox).
    NIXOS_OZONE_WL = "1";                       # Enables the Ozone Wayland backend for Chromium-based browsers.
    NIXPKGS_ALLOW_UNFREE = "1";                 # Allows the installation of packages with unfree licenses in Nixpkgs.
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";  # Disables window decorations in Qt applications when using Wayland.
    SDL_VIDEODRIVER = "wayland";                # Sets the video driver for SDL applications to Wayland.
  };

  # -----------------------------------------------
  # Enables simultaneous use of processor threads.
  # -----------------------------------------------
  security = {
    allowSimultaneousMultithreading = true;
    rtkit.enable = true; 
  };

  #---------------------------------------------------------------------
  # Networking
  #---------------------------------------------------------------------
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = true;

      connectionConfig = {
        "ethernet.mtu" = 1462;
        "wifi.mtu" = 1462;
      };
    };    
    hostName = "${hostname}";
    firewall.allowedTCPPorts = [ 22 ];
  };

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
  users = {
    groups.${name} = {
      members = [ ];
    };

    extraUsers.${name} = {
      name = "${name}";
      group = "${name}";  
    };

    users."${name}" = {
      isNormalUser = true;
      description = "${name}";
      extraGroups = [
        "${name}"
        "adbusers"
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
        # Internet related
        firefox

        # Personal
        bcachefs-tools
        keyutils
        acpi
        clementine
        ethtool
        flameshot
        gimp-with-plugins
        git
        git-up
        gnome.gvfs
        gnome.rygel
        gupnp-tools   # UPNP tools USAGE: gupnp-universal-cp
        kate
        libnotify
        libwps
        lolcat
        mesa
        neofetch
        notify
        notify-desktop
        variety
        wpsoffice

        # Gnome related / extensions
        # gnomeExtensions.emoji-copy
        # unstable.gnomeExtensions.workspace-switcher-manager
        gnome-extension-manager
        gnome-usage
        gnome.dconf-editor
        gnome.gnome-disk-utility
        gnome.gnome-tweaks
        gnomeExtensions.appindicator
        gnomeExtensions.dash-to-dock
        gnomeExtensions.just-perfection
        gnomeExtensions.logo-menu
        gnomeExtensions.wifi-qrcode
        gnomeExtensions.wireless-hid
        gnome.simple-scan

        # Development 
        direnv
        nixfmt-rfc-style
        vscode
        vscode-extensions.brettm12345.nixfmt-vscode

        # MegaSync related
        megasync

        # Intel related
        intel-gmmlib
        intel-media-driver
        intel-vaapi-driver
      ];

      openssh = { 
        authorizedKeys = {
          keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGg5V+YAm36cZcZBZz1fv7+0kP05DpoGs1EhcrlI09i kingtolga@gmail.com"
          ];
          keyFiles = [
            /home/${name}/.ssh/id_ed25519.pub
          ];
        };      
      };
    };
  };

  #---------------------------------------------------------------------
  # Audio settings
  #---------------------------------------------------------------------

  # Enable sound with pipewire.
  sound.enable = true;   

  # Enable UPNP for gupnp-tools   # UPNP tools USAGE: gupnp-universal-cp
  programs = {
    gnupg.agent.enable = true; 
    mtr.enable = true; 
    ssh.startAgent = true;  
  };

  #---------------------------------------------------------------------
  # Automatic system upgrades, automatically reboot after an upgrade if
  # necessary
  #---------------------------------------------------------------------
  system = {
    autoUpgrade.allowReboot = false;  # Very annoying if set to true
    autoUpgrade.enable = true;
    copySystemConfiguration = true;
    stateVersion = "23.05";  # Update this to match your system's current version.
  };  
}
