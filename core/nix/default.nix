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

  imports = [
    ./nixpkgs-config
  ];

  #---------------------------------------------------------------------  
  # Nix-specific settings and garbage collection options - 
  # Mostly research from NixOS wiki
  #---------------------------------------------------------------------  

  #---------------------------------------------------------------------
  # System optimisations
  #---------------------------------------------------------------------
  nix = {
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
