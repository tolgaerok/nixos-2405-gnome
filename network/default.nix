{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [
    # Import miniDLNA..
    # ------------------------------------------
    # ./plex.nix
    ./home-network
    ./miniDLNA.nix
  ];

  #--------------------------------------------------------------------- 
  # Enable networking
  #---------------------------------------------------------------------
  networking = {
    # wireless = {
    #  enable = true;
    #  userControlled.enable = true;
    #  networks = { "OPTUS_B27161" = { psk = "izardleary84422"; }; };
    # };

    networkmanager = {
      enable = true;
      # Append Cloudflare and Google DNS servers
      appendNameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];

      #--------------------------------------------------------------------- 
      # Prevent fragmentation and reassembly, which can improve network performance
      #---------------------------------------------------------------------
      connectionConfig = {
        "ethernet.mtu" = 1462;
        "wifi.mtu" = 1462;
      };
    };

    # terminal: arp -a
    extraHosts = ''
      127.0.0.1       localhost
      127.0.0.1       Nixos-Folio
      192.168.0.1     router
      192.168.0.2     DIGA            # Smart TV
      192.168.0.5     folio-F39       # HP Folio
      192.168.0.6     iPhone          # Dad's mobile
      192.168.0.7     Laser           # Laser Printer
      192.168.0.8     min21THIN       # EMMC thinClient
      192.168.0.10    TUNCAY-W11-ENT  # Dad's PC
      192.168.0.11    ubuntu-server   # CasaOS
      192.168.0.13    HP-G1-800       # Main NixOS rig
      192.168.0.15    KingTolga       # My mobile
      192.168.0.20    W11-SERVER      # Main home server

      # The following lines are desirable for IPv6 capable hosts
      ::1             localhost ip6-localhost ip6-loopback
      fe00::0         ip6-localnet
      ff00::0         ip6-mcastprefix
      ff02::1         ip6-allnodes
      ff02::2         ip6-allrouters
      ff02::3         ip6-allhosts
    '';
  };

  # Install network time protocol
  environment.systemPackages = with pkgs; [
    ntp
    gnome.rygel
  ];

  services.gnome.rygel.enable = true;

  # Wifi network monitor connector
  services.dbus.packages = [ pkgs.miraclecast ];

  # Enable the NTP service
  services.ntp = {
    enable = true;
    servers = [
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
      "time.google.com"
      "time2.google.com"
      "time3.google.com"
      "time4.google.com"
    ];
  };
}
