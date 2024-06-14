{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

#---------------------------------------------------------------------
# Tolga Erok
# 25/10/23
# My personal flathub automator and buffer to stop KDE Plasma
# locking up and black-screen of death 
#
# ¯\_(ツ)_/¯
#---------------------------------------------------------------------

{

  imports = [
    # Add additional imports here if needed
    # e.g., ./tmpfs-mount.service
  ];

  services.flatpak.enable = true;

  # ---------------------------------------------------------------------
  # Define systemd configuration settings
  # ---------------------------------------------------------------------
  systemd = {
    
  };

  systemd.services = {

    # ---------------------------------------------------------------------
    # Do not restart these services on configuration changes
    # Ideas borrowed from previous Fedora experiences
    # ---------------------------------------------------------------------
    NetworkManager.restartIfChanged = false;
    display-manager.restartIfChanged = false;
    libvirtd.restartIfChanged = false;
    polkit.restartIfChanged = false;
    systemd-logind.restartIfChanged = false;
    wpa_supplicant.restartIfChanged = false;

    # ---------------------------------------------------------------------
    # Helper service to lock screen before sleeping
    # ---------------------------------------------------------------------
    lock-before-sleeping = {
      restartIfChanged = false;
      unitConfig = {
        Description = "Helper service to bind locker to sleep.target";
      };
      serviceConfig = {
        ExecStart = "${pkgs.slock}/bin/slock";
        Type = "simple";
      };
      before = [ "pre-sleep.service" ];
      wantedBy = [ "pre-sleep.service" ];
      environment = {
        DISPLAY = ":0";
        XAUTHORITY = "/home/tolga/.Xauthority";
      };
    };

    # ---------------------------------------------------------------------
    # Configure the flathub remote
    # ---------------------------------------------------------------------
    configure-flathub-repo = {
      enable = true;
      after = [
        "multi-user.target"
        "network.target"
      ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        if flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo; then
          echo "¯\_(ツ)_/¯  Flathub repo added and configured successfully ==>  [✔] "
        else
          echo "¯\_(ツ)_/¯  Error: Failed to configure Flathub repo ==>  [✘]"
          exit 1;  # Exit with an error code to indicate failure
        fi
      '';
    };

    # ---------------------------------------------------------------------
    # Custom Info Script service
    # ---------------------------------------------------------------------
    customInfoScript = {
      description = "Custom Info Script";
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash /etc/nixos/core/system/systemd/custom-info-script.sh";
      };
    };

    # --------------------------------------------------------------------- 
    # Modify autoconnect priority of the connection to Tolga's home network
    # ---------------------------------------------------------------------
    modify-autoconnect-priority = {
      description = "Modify autoconnect priority of OPTUS_B27161 connection";
      script = ''
        nmcli connection modify OPTUS_B27161 connection.autoconnect-priority 1
      '';
    };

    # ---------------------------------------------------------------------
    # Check for updates using espeak and nixos-check-updates
    # ---------------------------------------------------------------------
    check-update = {
      serviceConfig.Type = "oneshot";
      path = [ pkgs.espeak-classic ];
      script = ''
        #!/bin/sh
        espeak -v en+m7 -s 165 "PUNK! " --punct=","
        nixos-check-updates
      '';
    };
  };

  # ---------------------------------------------------------------------
  # Timer to periodically check for updates
  # ---------------------------------------------------------------------
  systemd.timers.check-updates = {
    wantedBy = [ "timers.target" ];
    partOf = [ "check-update.service" ];
    timerConfig = {
      # Run every 10 seconds
      OnCalendar = "*-*-* *-*-*:00/10:00:00";
      Unit = "check-update.service";
    };
  };

  # ---------------------------------------------------------------------
  # Ensure the custom info script is executable and run during activation
  # ---------------------------------------------------------------------
  system.activationScripts.customInfoScript = lib.mkAfter ''
    ${pkgs.bash}/bin/bash /etc/nixos/core/system/systemd/custom-info-script.sh
  '';
}