{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.intel;
in
{
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };

    # OpenGL
    hardware.opengl = {
      extraPackages = with pkgs; [
        intel-gmmlib
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        vaapiIntel
        vaapiVdpau 
      ];
    };
  };
}
