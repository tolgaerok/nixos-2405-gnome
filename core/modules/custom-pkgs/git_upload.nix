{
  config,
  pkgs,
  lib,
  ...
}:

let

  gitup = pkgs.writeScriptBin "gitup" ''
    #!/usr/bin/env bash

    # Personal nixos git folder uploader!!
    # Tolga Erok. ¯\_(ツ)_/¯..
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

    # Check if the remote URL is set to SSH
    remote_url=$(git remote get-url origin)

    # Configure Git credential helper to cache credentials for 1 hour
    git config --global credential.helper "cache --timeout=3600"

    if [[ $remote_url == *"git@github.com"* ]]; then
        echo ""
        echo "Remote URL is set to SSH. Proceeding with the script..." | ${pkgs.lolcat}/bin/lolcat
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

    # Add all changes
    git add .

    # Print the status for debugging
    echo "Git status before committing:"
    git status

    # Check if there are changes to commit
    if git diff --cached --exit-code &>/dev/null; then
        echo "No changes to commit."
    else
        echo "Changes detected, committing..."
        # Commit changes with custom message
        git commit -m "$COMMIT_MSG"

        # Pull changes from the remote repository to avoid conflicts
        echo "Pulling changes from remote repository..."
        git pull --rebase origin main

        # Push changes to the main branch
        echo "Pushing changes to remote repository..."
        git push origin main
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
