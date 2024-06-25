{
  config,
  pkgs,
  lib,
  username,

  ...
}:

#----------------------------------------------------------------------
# SystemD settings
#----------------------------------------------------------------------

with lib;
let
  username = builtins.getEnv "USER";
  name = "tolga";

  createUserXauthority = lib.mkForce ''
    if [ ! -f "/home/${name}/.Xauthority" ]; then
      xauth generate :0 . trusted
      touch /home/${name}/.Xauthority
      chmod 600 /home/${name}/.Xauthority
    fi
  '';
in

#---------------------------------------------------------------------
# Tolga Erok
# 15-Jun-2024
# My personal systemD scripts
#
# ¯\_(ツ)_/¯
#---------------------------------------------------------------------

{
  imports = [
    # ./tmpfs-mount.service
  ];  
  
  # ---------------------------------------------------------------------
  # Add a systemd tmpfiles rule that creates a directory /var/spool/samba 
  # with permissions 1777 and ownership set to root:root. 
  # ---------------------------------------------------------------------
  systemd = {

    # Define rules for managing directories, permissions, and file removal in system temporary directories
    tmpfiles.rules = [
      "D! /tmp 1777 root root 0"            # Create /tmp with 1777 permissions, owned by root user and group, and clear it at boot
      "d /Universal 0755 ${name} ${name} -" # Create /Universal with 0755 permissions, owned by ${name} user and group
      "d /nix/var/nix/profiles/per-user/${name} 0755 ${name} root -"  # Create /nix/var/nix/profiles/per-user/${username} with 0755 permissions, owned by ${username} user and root group
      "d /var/spool/samba 1777 root root -" # Create /var/spool/samba with 1777 permissions, owned by root user and group
      "r! /tmp/**/*"                        # Recursively remove all files and directories in /tmp
    ];

    # Default timeout for stopping services managed by systemd to 10 seconds
    extraConfig = "DefaultTimeoutStopSec=10s";

    # When a program crashes, systemd will create a core dump file, typically in the /var/lib/systemd/coredump/ directory.
    coredump.enable = true;

    # If a kernel-level OOM event does occur anyway,
    # strongly prefer killing nix-daemon child processes
    # Define resource limits and OOM handling for the nix-daemon process group
    slices."nix-daemon".sliceConfig = {

      # Define resource limits and management settings for systemd services
      MemoryHigh = "2G";                      # Set the high memory limit to 2GB
      MemoryMax = "3G";                       # Set the maximum memory limit to 3GB
      CPUQuota = "50%";                       # Limit the CPU usage to 50%
      ManagedOOMMemoryPressure = "kill";      # Configure OOM management to kill the service under high memory pressure
      ManagedOOMMemoryPressureLimit = "95%";  # Trigger OOM management when memory pressure reaches 95%
    };

    # Associate nix-daemon systemd service with resource constraints and OOM settings
    services."nix-daemon".serviceConfig = {

      # Define slice and OOM score adjustment for systemd services
      Slice = "nix-daemon.slice"; # Assign the service to the nix-daemon.slice
      OOMScoreAdjust = 1000;      # Set the OOM (Out of Memory) score adjustment to 1000
    };
  };

  systemd.services = {
    # ---------------------------------------------------------------------
    # Do not restart these, since it messes up the current session
    # Idea's used from previous fedora woe's
    # ---------------------------------------------------------------------
    NetworkManager.restartIfChanged = false;
    display-manager.restartIfChanged = false;
    libvirtd.restartIfChanged = false;
    polkit.restartIfChanged = false;
    systemd-logind.restartIfChanged = false;
    wpa_supplicant.restartIfChanged = false;

    # lock-before-sleeping = {
    #  restartIfChanged = false;
    #  unitConfig = {
    #    Description = "Helper service to bind locker to sleep.target";
    #  };

    #  serviceConfig = {
    #    ExecStart = "${pkgs.slock}/bin/slock";
    #    Type = "simple";
    #  };

    # before = [ "pre-sleep.service" ];
    # wantedBy = [ "pre-sleep.service" ];

    #  environment = {
    #    DISPLAY = ":0";
    #    XAUTHORITY = "/home/${username}/.Xauthority";
    #  };
    # };

    # Prefetch updates, Improves Update Efficiency
    update-prefetch = {
      enable = true;
    };

    # Enables Multi-Gen LRU and sets minimum TTL for memory management
    mglru = {
      enable = true;
      wantedBy = [ "basic.target" ];
      script = ''
        ${pkgs.coreutils-full}/bin/echo 1000 > /sys/kernel/mm/lru_gen/min_ttl_ms
      '';
      serviceConfig = {
        Type = "oneshot";
      };
      unitConfig = {
        ConditionPathExists = "/sys/kernel/mm/lru_gen/enabled";
        Description = "Configure Enable Multi-Gen LRU";
      };
    };

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
      description = "Bind mount /home/${name}/MyGit to /mnt/MyGit";
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/mount --bind /home/${name}/MyGit /mnt/MyGit";
        RemainAfterExit = true;
      };
      wantedBy = [ "multi-user.target" ];
    };

    # Ensure correct ownership of /Universal
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
    # "io-scheduler" = {
    #  description = "Set I/O Scheduler on boot - Tolga Erok";
    #  wantedBy = [ "multi-user.target" ];
    #  serviceConfig = {
    #    Type = "oneshot";
    #    ExecStart = "${pkgs.bash}/bin/bash -c 'echo -e \"Configuring I/O Scheduler to: \"; echo \"none\" | ${pkgs.coreutils}/bin/tee /sys/block/sda/queue/scheduler; printf \"I/O Scheduler has been set to ==>  \"; cat /sys/block/sda/queue/scheduler; echo \"\"'";
    #  };
    #  enable = true;
    # };

    # Create missing home directories and set ownership
    # check-create-user-home-dirs = {
    #  description = "Ensure user home directories are created and owned by the user";
    #  after = [ "network.target" ];
    #  wantedBy = [ "default.target" ];
    #  serviceConfig = {
    #    Type = "oneshot";
    #    ExecStart = ''
    #      ${pkgs.bash}/bin/bash -c 'if id -u ${name} >/dev/null 2>&1 && id -g ${name} >/dev/null 2>&1; then \
    #        for dir in Documents Downloads Music Pictures Videos MyGit DLNA Applications Universal .icons .ssh; do \
    #          mkdir -p /home/${name}/$dir && chown ${name}:${name} /home/${name}/$dir; \
    #        done; \
    #      fi'
    #    '';
    #  };
    #  enable = true;
    # };

    # Disable specific systemd services
    "NetworkManager-wait-online".enable = false;  # Disable the NetworkManager-wait-online service
    "systemd-udev-settle".enable = false;         # Disable the systemd-udev-settle service
    "getty@tty1".enable = false;                  # Disable the getty@tty1 service
    "autovt@tty1".enable = false;                 # Disable the autovt@tty1 service

    # Configure the flathub remote
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
          exit 1  # Exit with an error code to indicate failure
        fi
      '';
    };

    # customInfoScript = {
    #  description = "Custom Info Script";
    #  after = [ "multi-user.target" ];
    #  wantedBy = [ "multi-user.target" ];
    #  serviceConfig = {
    #    ExecStart = "${pkgs.bash}/bin/bash /etc/nixos/core/system/systemd/custom-info-script.sh";
    #  };
    # };

    # Modify autoconnect priority of the connection to tolgas home network
    modify-autoconnect-priority = {
      description = "Modify autoconnect priority of OPTUS_B27161 connection";
      script = ''
        nmcli connection modify OPTUS_B27161 connection.autoconnect-priority 1
      '';
    };
  };

  # Ensure the script is executable and run the script as part of the activation
  system.activationScripts = {
    customInfoScript = lib.mkAfter ''
      ${pkgs.bash}/bin/bash /etc/nixos/core/system/systemd/custom-info-script.sh
    '';

    # Test (create directories)
    text = ''
      for dir in MUM DAD WORK SNU Documents Downloads Music Pictures Videos MyGit DLNA Applications Universal .icons .ssh; do
        mkdir -p /home/${name}/$dir
        chown ${name}:${name} /home/${name}/$dir
      done
    '';

    # Create custom auto start files
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
        X-GNOME-Autostart-Delay=2
        EOF
      '';
    };

    variety-start = {
      text = ''
        cat << EOF > /home/${name}/.config/autostart/variety.desktop
        [Desktop Entry]
        Name=Variety
        Comment=Variety Wallpaper Changer
        Categories=GNOME;GTK;Utility;
        Exec=variety %U
        MimeType=text/uri-list;x-scheme-handler/variety;x-scheme-handler/vrty;
        Icon=variety
        Terminal=false
        Type=Application
        StartupNotify=false
        Actions=Next;Previous;PauseResume;History;Preferences;
        Keywords=Wallpaper;Changer;Change;Download;Downloader;Variety;
        StartupWMClass=Variety

        [Desktop Action Next]
        Exec=variety --next
        Name=Next

        [Desktop Action Previous]
        Exec=variety --previous
        Name=Previous

        [Desktop Action PauseResume]
        Exec=variety --toggle-pause
        Name=Pause / Resume

        [Desktop Action History]
        Exec=variety --history
        Name=History

        [Desktop Action Preferences]
        Exec=variety --preferences
        Name=Preferences
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
}