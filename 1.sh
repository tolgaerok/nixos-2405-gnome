#!/bin/bash

# Directory of your Git repository
REPO_DIR="/etc/nixos"

# Commit message with timestamp and custom changes
COMMIT_MSG="$(date '+%Y-%m-%d %H:%M:%S') - $@ ¯\_(ツ)_/¯"

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

    # Push changes to the main branch
    git push origin main
fi
