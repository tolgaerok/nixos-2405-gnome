{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  description = "My Qnap";
  device = "//192.168.0.17/public";
  name = "tolga";
  protocol = "smb:";
in
{
  # Custom remote mount
  fileSystems."/mnt/QNAP" = {
    device = "${device}";
    fsType = "cifs";
    options =
      let
        # Network mount Options
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},credentials=/etc/nixos/network/smb-secrets,uid=1000,gid=100" ];
  };

  services = {
    gvfs.enable = true;     # Enable GVFS service
    rpcbind.enable = true;  # Enable RPC bind service
  };

  environment.systemPackages = with pkgs; [
    bash                    # Install Bash as a system package
  ];

  systemd.services.addBookmark = {
    description = "Add SMB bookmark to GTK 3.0 bookmarks";  # Description of the systemd service

    # Overwrite the bookmarks file with the new bookmark entry (>) do not append (>>)
    script = ''
      echo "${protocol}${device} ${description}" > ${config.users.users.${name}.home}/.config/gtk-3.0/bookmarks
    '';

    wantedBy = [ "multi-user.target" ];   # Target to start the service
    serviceConfig = {
      Type = "oneshot";                   # systemd service (one-shot)
    };
  };
}
