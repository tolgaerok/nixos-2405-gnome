{
  config,
  pkgs,
  lib,
  ...
}:

let

  gitup = pkgs.writeScriptBin "gitup" ''
    #!/usr/bin/env bash
    # Tolga Erok
    # 10/6/2024
    # git uploader version #2

    set -e

    # Personal nixos git folder uploader!!
    # Tolga Erok. ¯\\_(ツ)_/¯..
    # 20/8/23.

    start_time=$(date +%s)
    # Directory of your Git repository
    REPO_DIR="/etc/nixos"

    # Commit message with timestamp and custom changes in Australian format..
    COMMIT_MSG="(ツ)_/¯ Edit: $(date '+%d-%m-%Y %I:%M:%S %p')"

    # Add some tweaks
    git config --global core.compression 9
    git config --global core.deltaBaseCacheLimit 2g
    git config --global diff.algorithm histogram
    git config --global http.postBuffer 524288000

    # Ensure the Git repository is initialized
    if [ ! -d "$REPO_DIR/.git" ]; then
        echo "Initializing Git repository in $REPO_DIR..."
        git init "$REPO_DIR"
        git remote add origin git@github.com:tolgaerok/nixos-2405-gnome.git
    fi

    # Check if the remote URL is set to SSH
    remote_url=$(git -C "$REPO_DIR" remote get-url origin)

    # Configure Git credential helper to cache credentials for 1 hour
    git config --global credential.helper "cache --timeout=3600"

    if [[ $remote_url == *"git@github.com"* ]]; then
        echo ""
        echo "Remote URL is set to SSH. Proceeding with the script..." | lolcat
        echo ""
    else
        echo "Remote URL is not set to SSH. Please set up SSH key-based authentication for the remote repository."
        echo "If you haven't already, generate an SSH key pair:"
        echo "ssh-keygen -t ed25519 -C 'your email'"
        echo "Add your SSH key to the agent:"
        echo "eval \$(ssh-agent -s)"
        echo "ssh-add ~/.ssh/id_ed25519"
        echo "Then, add your SSH public key to your GitHub account:"
        echo "cat ~/.ssh/id_ed25519.pub"
        echo "Finally, update your Git configuration to use SSH:"
        echo "git config --global credential.helper store"
        echo "Remote URL needs to be updated to SSH. Exiting..."
        exit 1
    fi

    # Navigate to the repository directory
    cd "$REPO_DIR" || exit

    # Check if a rebase is in progress
    if [ -d "$REPO_DIR/.git/rebase-merge" ]; then
        echo "A rebase is currently in progress. Please resolve it before running this script."
        echo "You can either continue the rebase with 'git rebase --continue' or abort it with 'git rebase --abort'."
        exit 1
    fi

    # Print the current working directory for debugging
    echo "Current working directory: $(pwd)"

    # Add all changes
    git add .

    # Print the status for debugging
    echo "Git status before committing:"
    git status

    # Check if there are changes to commit
    if git status --porcelain | grep -qE '^\s*[MARCDU]'; then
        echo "Changes detected, committing..."
        # Commit changes with custom message
        git commit -am "$COMMIT_MSG"

        # Pull changes from the remote repository to avoid conflicts
        echo "Pulling changes from remote repository..."
        git pull --rebase origin main

        # Push changes to the main branch
        echo "Pushing changes to remote repository..."
        git push origin main
        figlet files && figlet uploaded
    else
        echo "No changes to commit."
        figlet Nothing to && figlet Upload
    fi        

    end_time=$(date +%s)

    

    time_taken=$((end_time - start_time))

    notify-send --icon=ktimetracker --app-name="DONE" "Uploaded " "Completed:

        (ツ)_/¯
    Time taken: $time_taken
    " -u normal

  '';
in

{

  #---------------------------------------------------------------------
  # Type: gitup in terminal to execute above bash script
  #---------------------------------------------------------------------

  environment.systemPackages = [ gitup ];
}
