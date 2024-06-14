{ config, lib, pkgs, modulesPath, ... }:

  #---------------------------------------------------------------------
  # Personal samba-share && mount point..
  #---------------------------------------------------------------------

{ 

  fileSystems."/mnt/QNAP-PRO" = {
    device = "//192.168.0.17";
    fsType = "cifs";
    options = let
      automountOpts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,x-systemd.requires=network.target";

      # Replace with your actual user ID, use `id -u <YOUR USERNAME>` to get your user ID  
      uid = "1000"; 
      # Replace with your actual group ID, use `id -g <YOUR USERNAME>` to get your group ID
      gid = "100"; 

      vers = "3.1.1";
      cacheOpts = "cache=loose";
      credentialsPath = "/etc/nixos/network/smb-secrets";
    in [
      "${automountOpts},credentials=${credentialsPath},uid=${uid},gid=${gid},rw,vers=${vers},${cacheOpts}"
    ];

  };

  

}
