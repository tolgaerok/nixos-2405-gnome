{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.sys.desktop;
in
{

  # -----------------------------------------------
  # X11 settings
  # -----------------------------------------------

  # Enable the X11 windowing system and keymap.
  services = {
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    ipp-usb.enable = true;

    smartd = {
      enable = true;
      autodetect = true;
    };

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
      videoDrivers = [ "intel" ];
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
  hardware = {
    opengl = {
      enable = true;
    };
  };
  programs = {
    xwayland = {
      enable = true;
    };
  };
  # Enable and configure xdg portals.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [
      # pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];

  };
}
