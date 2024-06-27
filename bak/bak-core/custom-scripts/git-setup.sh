#!/usr/bin/env bash

# Function to install required packages
install_packages() {
    local packages=("$@")
    for package in "${packages[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            echo "Installing $package..."
            sudo nix-env -iA nixpkgs.$package
        else
            echo "$package is already installed."
        fi
    done
}

setup_git() {
    echo
    echo "Git setup..."

    local dependencies=("git")
    install_packages "${dependencies[@]}"

    # Check if user.name is configured
    if [ -z "$(git config --get user.name)" ]; then
        read -p "Enter username: " username
        git config --global user.name "$username"
    else
        echo "User name is already configured."
    fi

    # Check if user.email is configured
    if [ -z "$(git config --get user.email)" ]; then
        read -p "Enter email: " email
        git config --global user.email "$email"
    else
        echo "User email is already configured."
    fi

    if [ -d ~/.ssh ] && [ -n "$(ls -A ~/.ssh)" ]; then
        echo -e "The directory ~/.ssh already exists and it is not empty.\nProceeding could potentially overwrite any existing SSH key. A manual check will be required."
        return 0
    fi

    echo "Press enter to accept the default key location."
    ssh-keygen -t ed25519 -C "$(git config --get user.email)"

    eval "$(ssh-agent -s)"

    ssh-add ~/.ssh/id_ed25519

    echo -e "Copy to your clipboard the following generated SSH key and manually add it to your GitHub account.\nGo to: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account and follow from step 2."
    echo
    cat ~/.ssh/id_ed25519.pub

    # Optionally initialize a new Git repository
    read -p "Do you want to initialize a new Git repository here? (y/n) " init_repo
    if [ "$init_repo" = "y" ]; then
        git init
        echo "Initialized a new Git repository."
    else
        echo "Git repository initialization skipped."
    fi

    # Optionally add files to the repository
    read -p "Do you want to add all files to the repository? (y/n) " add_files
    if [ "$add_files" = "y" ]; then
        git add .
        echo "Added all files to the repository."
    else
        echo "File addition skipped."
    fi

    # Optionally make the first commit
    read -p "Do you want to make the first commit? (y/n) " first_commit
    if [ "$first_commit" = "y" ]; then
        read -p "Enter commit message: " commit_message
        git commit -m "$commit_message"
        echo "First commit made."
    else
        echo "First commit skipped."
    fi
}

# Execute the setup_git function
setup_git
