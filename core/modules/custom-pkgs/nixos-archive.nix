{ config, pkgs, lib, ... }:

let

  nixos-archive = pkgs.writeScriptBin "nixos-archive" ''
    #!/bin/bash
    # Personal nixos folder archiver backup
    # Tolga Erok. ¯\_(ツ)_/¯
    # 9/9/2023

    # Define the backup folder path within /etc/nixos
    backup_folder="/etc/nixos/NIXOS-ARCHIVES"

    # Get the current date and time in the required format
    current_date=$(date +"%Y %b %a-%l-%M%p")
    backup_subfolder=$(date +"%Y/%b/%a-%l-%M%p")

    # Create the backup folder structure if it doesn't exist
    mkdir -p "$backup_folder/$backup_subfolder"

    # Define the backup filename without extension
    backup_filename=$(date +"%a-%l-%M%p")

    # Zip the contents of /etc/nixos without the folder structure
    zip -r "$backup_folder/$backup_subfolder/$backup_filename.zip" /etc/nixos/* -x "/etc/nixos/NIXOS-ARCHIVES/*"

    echo "Backup completed and stored in $backup_folder/$backup_subfolder/$backup_filename.zip"

  '';

in {
  #---------------------------------------------------------------------
  # Type: nixos-archive in terminal to execute above bash script
  #---------------------------------------------------------------------

  environment.systemPackages = [ nixos-archive ];

  #---------------------------------------------------------------------
  # Create systemd service and timer for nixos-archive
  #---------------------------------------------------------------------

  #systemd = {
  #  services.nixos-archive = {
  #    description = "NixOS backups";
  #    serviceConfig = {
  #      ExecStart = "${nixos-archive}/bin/nixos-archive >> /home/tolga/test.log 2>&1";
  #      Type = "oneshot";
  #    };
  #    path = [ nixos-archive ];
  #  };

  #  timers.nixos-archive = {
  #    description = "Run nixos-archive hourly";
  #    timerConfig = {
  #      OnCalendar = "hourly";
  #    };
  #    wantedBy = [ "timers.target" ];
  #  };
  #};

  # Disable cron jobs if not needed
  #services.cron = {
  #  enable = false;
  #};
}
