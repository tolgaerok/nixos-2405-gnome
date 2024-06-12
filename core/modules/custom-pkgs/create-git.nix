{ config, pkgs, lib, ... }:

let

  create-git = pkgs.writeScriptBin "create-git" ''
    #!/usr/bin/env bash

    # Tolga Erok
    # 14/7/2023
    # Post git setup!
    # ¯\_(ツ)_/¯

    RED='\e[1;31m'
    GREEN='\e[1;32m'
    YELLOW='\e[1;33m'
    BLUE='\e[1;34m'
    CYAN='\e[1;36m'
    WHITE='\e[1;37m'
    ORANGE='\e[1;93m'
    NC='\e[0m'

    clear

    echo -e "\\033[34;1mCreate git parameters\\033[0m"
    echo -e "\\033[34;1mBy \\033[33mTolga Erok\\033[0m"

    # -----------------------------------------------------------------------------------
    #  Setup GIT on system
    # -----------------------------------------------------------------------------------

    echo ""
    echo -e "\\033[34;1m ¯\_(ツ)_/¯ \\033[0m Setting up GIT on system ... \n"

    # Check if user.name is configured
    if [ -z "$(git config --global user.name)" ]; then
        echo ""
        read -p "Enter username: " username
        git config --global user.name "$username"
    else
        echo ""
        echo -e "\\033[34;1m ¯\_(ツ)_/¯  \\033[0m User name is already configured ... \n"
        echo ""
    fi

    # Check if user.email is configured
    if [ -z "$(git config --global user.email)" ]; then
        read -p "Enter email: " email
        git config --global user.email "$email"
    else
        echo ""
        echo -e "\\033[34;1m ¯\_(ツ)_/¯  \\033[0m (@) EMAIL is already configured ... \n"
        echo ""
    fi

    if [ -d ~/.ssh ] && [ -n "$(ls -A ~/.ssh)" ]; then
        echo ""
        echo -e "\\033[34;1mThe directory ~/.ssh already exists and is not empty.\nProceeding could potentially overwrite any existing ssh key. A manual check will be required... \n"
        exit 0
    fi

    echo ""
    echo -e "\\033[34;1m ¯\_(ツ)_/¯ \\033[0m Press enter to accept the default key location... \n"
    ssh-keygen -t ed25519 -C "$email"

    eval "$(ssh-agent -s)"

    ssh-add ~/.ssh/id_ed25519

    echo -e "\\033[34;1mCopy the following generated ssh key to your clipboard\nand manually add it to your GitHub account. Go to:\nhttps://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account\nand follow from step 2... \n"
    echo
    cat ~/.ssh/id_ed25519.pub

    echo -e "\\033[34;1m ¯\_(ツ)_/¯ \\033[0m Setting up complete \n"

    
    # Pause and continue
    echo -e "\nContinuing..."
    read -r -n 1 -s -t 1
    sleep 1
  '';
in {

  #---------------------------------------------------------------------
  # Type: create-git in terminal to execute above bash script
  #---------------------------------------------------------------------

  environment.systemPackages = [ create-git ];
}
