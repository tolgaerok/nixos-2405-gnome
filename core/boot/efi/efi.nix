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
  imports = [
    # Intialise tmpfs parameters.
    ../tmpfs/tmpfs.nix
    ../numlock
    ../mounts
    ../binds
  ];

  # Various plymouth themes
  environment = {
    systemPackages = with pkgs; [ plymouth ];
  };

  #---------------------------------------------------------------------
  # Bootloader - EFI
  #---------------------------------------------------------------------
  boot = {

    loader = {
      efi.canTouchEfiVariables = true; # Enables the ability to modify EFI variables.

      grub = {
        copyKernels = true;
        useOSProber = true;
        memtest86.enable = true;
        extraFiles = {
          "netbootxyz.efi" = "${pkgs.netbootxyz-efi}";
        };
        theme = pkgs.fetchFromGitHub {
          owner = "shvchk";
          repo = "fallout-grub-theme";
          rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
          sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
        };
        extraEntries = ''
          menuentry "iPXE" {
            chainloader /netbootxyz.efi
          }
        '';
      };
      systemd-boot = {
        consoleMode = "max"; # Sets the console mode to the highest resolution supported by the firmware.
        enable = true; # Activates the systemd-boot bootloader.
        memtest86.enable = true; # Enables the MemTest86+ option in the systemd-boot menu.
      };
    };

    # plymouth
    plymouth = {
      enable = true;
      theme = "breeze"; # breeze or bgrt
    };
  };
}
