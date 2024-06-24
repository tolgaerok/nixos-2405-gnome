{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
in
{
  # -----------------------------------------------
  # X11 settings
  # -----------------------------------------------

  # Enable the X11 windowing system and keymap.
  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      
      displayManager.gdm = {
        enable = true;
        wayland = true; # Enable Wayland for GDM
        settings = {
          daemon = {
            wayland = true; # Enable Wayland in the GDM settings
          };
        };
      };
      desktopManager.gnome.enable = true;
      xkb.layout = "au";
      xkb.variant = "";
    };

    # Enable libinput.
    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
      };
    };

    dbus.enable = true;
  };

  # Enable and configure xdg portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      # xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
}
