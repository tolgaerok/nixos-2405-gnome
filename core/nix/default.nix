{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

let

  name = "tolga";
in
{

  imports = [ ./nixpkgs-config ];

  #---------------------------------------------------------------------  
  # Nix-specific settings and garbage collection options - 
  # Mostly research from NixOS wiki
  #---------------------------------------------------------------------  

  #---------------------------------------------------------------------
  # System optimisations
  #---------------------------------------------------------------------
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      builders-use-substitutes = true
    '';
    settings = {
      allowed-users = [
        "@wheel"
        "${name}"
      ];
      auto-optimise-store = true;

      experimental-features = [
        "flakes"
        "nix-command"
        "repl-flake"
      ];
      cores = 0;
      sandbox = "relaxed";

      # Accelerate package building (optimized for 8GB RAM and dual-core processor with Hyper-Threading)
      max-jobs = lib.mkDefault 4;    # Set to 4 as the i7-3667U has 2 cores with 4 threads.
      buildCores = lib.mkDefault 4;
      supportedFeatures = [ "big-parallel" ];
      speedFactor = 2;

      trusted-users = [
        "${name}"
        "@wheel"
        "root"
      ];

      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = false;
      tarball-ttl = 300;

      trusted-substituters = [ "http://cache.nixos.org" ];
      substituters = [ "http://cache.nixos.org" ];
    };

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedPriority = 7;

    gc = {
      automatic = true;
      dates = "weekly";
      randomizedDelaySec = "14m";
      options = "--delete-older-than 10d";
    };
  };
}
