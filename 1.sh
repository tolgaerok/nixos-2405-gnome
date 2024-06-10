#!/bin/bash

# Directory of your Git repository
REPO_DIR="/etc/nixos"

# Commit message with timestamp and custom changes
COMMIT_MSG="$(date '+%Y-%m-%d %H:%M:%S') - $@ ¯\_(ツ)_/¯"

# Navigate to the repository directory
cd "$REPO_DIR" || exit

# Check if there are changes to commit
if git status --porcelain | grep -q .; then
    # Add all changes
    git add .

    # Commit changes with custom message
    git commit -m "$COMMIT_MSG"

    # Push changes to the default branch (change 'main' to your default branch name if different)
    git push origin main
else
    echo "No changes to commit."
fi
