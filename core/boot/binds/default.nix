{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
with lib;
let
  name = "tolga";
in
{

  # Add a file system entry for the "DLNA" directory bind mount
  fileSystems."/mnt/DLNA" = {
    device = "/home/${name}/DLNA/";
    fsType = "none";
    options = [
      "rw"
      "bind"
    ];
  };

  # Add a file system entry for the "Gimp" bind mount
  fileSystems."/mnt/GIMP" = {
    device = "/home/${name}/Pictures/CUSTOM-WALLPAPERS/";
    fsType = "none";
    options = [
      "rw"
      "bind"
    ];
  };

  # Add a file system entry for the "MyGit" directory bind mount
  fileSystems."/mnt/MyGit" = {
    device = "/home/${name}/MyGit/";
    fsType = "none";
    options = [
      "rw"
      "bind"
    ];
  };
}
