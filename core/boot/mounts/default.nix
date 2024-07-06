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

    # Add the bookmark entry only if it doesn't already exist
    script = ''
      bookmark="${protocol}${device} ${description}"
      bookmark_file=${config.users.users.${name}.home}/.config/gtk-3.0/bookmarks
      if ! grep -Fxq "$bookmark" "$bookmark_file"; then
        echo "$bookmark" >> "$bookmark_file"
      fi
    '';

    wantedBy = [ "multi-user.target" ];   # Target to start the service
    serviceConfig = {
      Type = "oneshot";                   # systemd service (one-shot)
    };
  };
}
