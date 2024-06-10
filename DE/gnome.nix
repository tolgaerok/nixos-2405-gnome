{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
let
  mesa =
    (pkgs.mesa.override {
      galliumDrivers = [
        "zink"
        "iris"
        "i915"
        "swrast"
        "auto"
      ];
      vulkanDrivers = [
        "intel"
        "swrast"
      ];
      enableGalliumNine = false;
      enableOSMesa = true;
      enableOpenCL = true;
    }).overrideAttrs
      (old: {
        mesonFlags = (lib.lists.remove "-Dxvmc-libs-path=${placeholder "drivers"}/lib" old.mesonFlags) ++ [
          "-D vulkan-layers=device-select,overlay"
        ];
        buildInputs = old.buildInputs ++ [ pkgs.glslang ];
        postInstall =
          old.postInstall
          + ''
            ln -s -t $drivers/lib/ ${pkgs.vulkan-loader}/lib/lib*
          '';
      });
  mesa32 =
    (pkgs.driversi686Linux.mesa.override {
      galliumDrivers = [
        "zink"
        "iris"
        "i915"
        "swrast"
        "auto"
      ];
      vulkanDrivers = [
        "intel"
        "swrast"
      ];
      enableGalliumNine = false;
      enableOSMesa = true;
      enableOpenCL = true;
    }).overrideAttrs
      (old: {
        mesonFlags = (lib.lists.remove "-Dxvmc-libs-path=${placeholder "drivers"}/lib" old.mesonFlags) ++ [
          "-D vulkan-layers=device-select,overlay"
        ];
        buildInputs = old.buildInputs ++ [ pkgs.glslang ];
        postInstall =
          old.postInstall
          + ''
            ln -s -t $drivers/lib/ ${pkgs.vulkan-loader}/lib/lib*
          '';
      });
in
{
  nixpkgs.overlays = [ ];
  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
          autoSuspend = false;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
        };
      };
      #useGlamor = true;
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = {
        enable = true;
      };
      jack = {
        enable = true;
      };
    };
  };
  hardware = {
    opengl = {
      enable = true;
      #package = mesa;
      #package32 = mesa32;
    };
    pulseaudio = {
      enable = false;
    };
  };
  programs = {
    xwayland = {
      enable = true;
    };
  };
  security = {
    rtkit = {
      enable = true;
    };
  };

  environment.systemPackages = [
    #pkgs-unstable.libsecret
  ];
  #environment.enableDebugInfo = true;
  #nixpkgs.overlays = [
  #  (final: prev: {
  #    gnome = prev.gnome.overrideScope' (gfinal: gprev: {
  #      gnome-session = gprev.gnome-session.overrideAttrs (attrs: {
  #        separateDebugInfo = true;
  #      });
  #      gnome-shell = gprev.gnome-shell.overrideAttrs (attrs: {
  #        separateDebugInfo = true;
  #      });
  #      mutter = gprev.mutter.overrideAttrs (attrs: {
  #        separateDebugInfo = true;
  #      });
  #    });
  #  })
  #];
}
