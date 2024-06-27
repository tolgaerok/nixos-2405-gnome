{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    numlock-boot.enable = lib.mkEnableOption "Boot with NumLock on";
  };

  config = mkIf config.numlock-boot.enable {
    services.xserver.displayManager.setupCommands = ''
      ${pkgs.numlockx}/bin/numlockx on
    '';
  };
}
