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
      cores = 0;               # Number of CPU cores allocated for the task (0 means all available cores)
      sandbox = "relaxed";     # Sandbox mode for running tasks, allowing broader system access for flexibility

      # Accelerate package building (optimized for 8GB RAM and dual-core processor with Hyper-Threading)
      max-jobs = lib.mkDefault 3;                # Set to 4 as the i7-3667U has 2 cores with 4 threads
      buildCores = lib.mkDefault 3;              # Specify 4 build cores for parallel building
      supportedFeatures = [ "big-parallel" ];    # Enable support for big parallel builds
      speedFactor = 3;                           # Set speed factor to 2 for build performance optimization


      trusted-users = [
        "${name}"
        "@wheel"
        "root"
      ];

      keep-derivations = true;    # Keep derivations (intermediate build artifacts) after build completion
      keep-outputs = true;        # Keep build outputs (resulting artifacts) after build completion
      warn-dirty = false;         # Disable warning for dirty builds (when sources have uncommitted changes)
      tarball-ttl = 300;          # Set the time-to-live (in seconds) for cached tarballs to 300 seconds (5 minutes)


      trusted-substituters = [ "http://cache.nixos.org" ];  # List of trusted substituters, where binaries can be fetched securely
      substituters = [ "http://cache.nixos.org" ];          # List of substituters, where binaries can be fetched (may include untrusted sources)

    };

    daemonCPUSchedPolicy = "idle";     # Set CPU scheduling policy for daemon processes to idle
    daemonIOSchedPriority = 7;         # Set I/O scheduling priority for daemon processes to 7


    gc = {
      automatic = true;                  # Enable automatic execution of the task
      dates = "weekly";                  # Schedule the task to run weekly
      randomizedDelaySec = "14m";        # Introduce a randomized delay of up to 14 minutes before executing the task
      options = "--delete-older-than 10d";  # Specify options for the task: delete files older than 10 days

    };
  };
}
