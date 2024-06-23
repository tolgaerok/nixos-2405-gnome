{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./miniDLNA.nix ];

  networking = {
    networkmanager = {
      enable = true;

      # NextDns config
      appendNameservers = [
        "DNS=45.90.28.0#48b246.dns.nextdns.io"
        "DNS=2a07:a8c0::#48b246.dns.nextdns.io"
        "DNS=45.90.30.0#48b246.dns.nextdns.io"
        "DNS=2a07:a8c1::#48b246.dns.nextdns.io"
        "DNSOverTLS=yes"
      ];
      connectionConfig = {
        "ethernet.mtu" = 1462;
        "wifi.mtu" = 1462;
      };
    };

    timeServers = [
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
      "time.google.com"
      "time2.google.com"
      "time3.google.com"
      "time4.google.com"
    ];

    extraHosts = ''
      127.0.0.1       localhost
      127.0.0.1       nixosFolio
      192.168.0.1     router
      192.168.0.2     DIGA            # Smart TV
      192.168.0.5     folio-F39       # HP Folio
      192.168.0.6     iPhone          # Dads mobile
      192.168.0.7     Laser           # Laser Printer
      192.168.0.8     min21THIN       # EMMC thinClient
      192.168.0.10    TUNCAY-W11-ENT  # Dads PC
      192.168.0.11    ubuntu-server   # CasaOS
      192.168.0.13    HP-G1-800       # Main NixOS rig
      192.168.0.15    KingTolga       # My mobile
      192.168.0.20    W11-SERVER      # Main home server
      ::1             localhost ip6-localhost ip6-loopback
      fe00::0         ip6-localnet
      ff00::0         ip6-mcastprefix
      ff02::1         ip6-allnodes
      ff02::2         ip6-allrouters
      ff02::3         ip6-allhosts
    '';
  };

  environment.systemPackages = with pkgs; [
    ntp
    gnome.rygel
  ];

  services = {
    gnome.rygel = {
      enable = true;
      # friendly_name = "NixOS-Rygel";
    };
  };
  

  networking.firewall = {
    allowedTCPPorts = [ 8200 ];
    allowedUDPPorts = [ 1900 ];
  };

  services.dbus.packages = [ pkgs.miraclecast ];
}
