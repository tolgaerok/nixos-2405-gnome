
# This configuration sets up `polkit-gnome` for managing user authentication dialogs and permissions in the GNOME desktop. 
# It enables simultaneous multithreading, integrates RealtimeKit for real-time priority management, 
# and ensures the `polkit-gnome-authentication-agent-1` service starts reliably during graphical sessions to handle authentication prompts.

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.polkit-gnome;
in

{
  options = {
    polkit-gnome = {
      enable = lib.mkEnableOption "Enable the main user module";
    };
  };

  config = lib.mkIf cfg.enable {

    # Set up the polkit-gnome-authentication-agent-1 service
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Enable simultaneous multithreading and RealtimeKit and Enable polkit for managing permissions
    security = {
      allowSimultaneousMultithreading = true;
      rtkit.enable = true;
      polkit.enable = true;
    };
  };
}
