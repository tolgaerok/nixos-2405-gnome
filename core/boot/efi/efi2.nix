{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with builtins;
let
  cfg = config.sys.boot;
  #mountPoint = "/boot";
  devices = "nodev";
  default = "saved";
in
{
  config = mkIf (cfg.bootloader == "uefi") {
    boot = {
      loader = {
        efi = {
          efiSysMountPoint = cfg.uefiPath;
          canTouchEfiVariables = true;
        };
        grub = {
          devices = [ devices ];
          efiSupport = true;
          configurationLimit = 5;
          useOSProber = true;
          default = default;
          enable = true;
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
      };
    };
  };
}
