{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Retrieve the username from configuration or set a default
  # username = config.users.extraUsers.username.name or "tolga";
  username = "tolga";
  mySharedPath = "/home/${username}/Public";
  mySharedPath2 = "/home/${username}/scripts";
  sharedOptions = {
    "guest ok" = true;
    "read only" = false;
    "valid users" = "@samba";
    browseable = true;
    writable = true;
  };
in
{
  services.samba-wsdd.enable = true;
  services.samba = {
    enable = true;
    package = pkgs.samba4Full;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      dns proxy = no
      name resolve order = lmhosts wins bcast host
      netbios name = ${config.networking.hostName}
      passdb backend = tdbsam
      security = user
      server role = standalone
      server string = Samba server (version: %v, protocol: %R)
      bind interfaces only = yes
      hosts allow = 127.0.0. 10. 172.16.0.0/255.240.0.0 192.168. 169.254. fd00::/8 fe80::/10 localhost
      hosts deny = allow
      deadtime = 30
      guest account = nobody
      inherit permissions = yes
      map to guest = bad user
      pam password change = yes
      use sendfile = yes
      socket options = SO_KEEPALIVE SO_REUSEADDR SO_BROADCAST TCP_NODELAY IPTOS_LOWDELAY IPTOS_THROUGHPUT SO_SNDBUF=262144 SO_RCVBUF=131072
      wins support = true
      read raw = yes
      write raw = yes
      max xmit = 65535
      large readwrite = yes
      client min protocol = COREPLUS
      server min protocol = COREPLUS
      aio read size = 1
      aio write size = 1
      vfs objects = acl_xattr catia streams_xattr
      vfs objects = catia streams_xattr
      client ipc max protocol = SMB3
      client ipc min protocol = COREPLUS
      client max protocol = SMB3
      server max protocol = SMB3
      log file = /var/log/samba/log.%m
      max log size = 500
      log level = 1 auth:3 smb:3 smb2:3
      ea support = yes
      fruit:metadata = stream
      fruit:model = Macmini
      fruit:veto_appledouble = no
      fruit:posix_rename = yes
      fruit:zero_file_id = yes
      fruit:wipe_intentionally_left_blank_rfork = yes
      fruit:delete_empty_adfiles = yes
      printcap name = cups
      load printers = yes
      cups options = raw
      disable spoolss = yes
    '';

    shares = {
      homes = sharedOptions // {
        comment = "Home Directories";
        browseable = true;
        "create mask" = "0700";
        "directory mask" = "0700";
        "valid users" = "%S, %D%w%S";
      };

      NixOS_Scripts = sharedOptions // {
        path = mySharedPath2;
        comment = "Public Share";
        "create mask" = "0777";
        "directory mask" = "0777";
      };

      NixOS_Private = sharedOptions // {
        path = "/home/NixOs";
        comment = "Private Share";
        "create mask" = "0644";
        "directory mask" = "0755";
        "guest ok" = false;
      };

      printers = sharedOptions // {
        comment = "All Printers";
        path = "/var/spool/samba";
        public = true;
        writable = false;
        printable = true;
        "create mask" = "0700";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${mySharedPath2} 0777 ${username} users - -"
    "d ${mySharedPath} 0777 ${username} users - -"    
  ];

  users.users.${username}.extraGroups = [ "samba" ];
}
