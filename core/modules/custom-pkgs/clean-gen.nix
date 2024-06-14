{ config, pkgs, ... }:

let

  nixos-gen-cleanup = pkgs.writeScriptBin "nixos-gen-cleanup" ''
    #!/bin/bash

    # Tolga Erok
    # Delete generations @ user choice

    start_time=$(date +%s)

    RED='\e[1;31m'
    GREEN='\e[1;32m'
    YELLOW='\e[1;33m'
    BLUE='\e[1;34m'
    CYAN='\e[1;36m'
    WHITE='\e[1;37m'
    ORANGE='\e[1;93m'
    NC='\e[0m'

    clear

    echo -e "\\033[34;1mClean up generations\\033[0m"
    echo -e "\\033[34;1mBy \\033[33mTolga Erok\\033[0m"

    # -----------------------------------------------------------------------------------
    #  Remove multiple generations
    # -----------------------------------------------------------------------------------
    echo -e "\n\\033[34;1m ¯\_(ツ)_/¯ \\033[0m Loading up generations, press control + C if not prompted for netxt stage \n"

    sudo /etc/nixos/core/modules/custom-pkgs/gen-del.sh 

    notify-send --icon=ktimetracker --app-name="Success" "Cleaned up. " "Selected generations deleted:

        (ツ)_/¯
    Time taken: $time_taken
    " -u normal

  '';
in
{

  #---------------------------------------------------------------------
  # Type: nixos-gen-cleanup in terminal to execute the above bash script
  #---------------------------------------------------------------------

  environment.systemPackages = [ nixos-gen-cleanup ];
}
