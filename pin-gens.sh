#!/usr/bin/env bash
clear
# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

# List all generations
echo "Available Generations:"
GENERATIONS=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations)
for GEN in $GENERATIONS; do
    GENERATION_NUMBER=$(echo "$GEN" | awk '{print $1}')
    GENERATION_DATE=$(echo "$GEN" | awk '{print $2, $3}')
    LINK_PATH="/nix/var/nix/profiles/system-${GENERATION_NUMBER}-link"
    MEANINGFUL_NAME=""
    if [ -L "$LINK_PATH" ]; then
        TARGET=$(readlink -f "$LINK_PATH")
        MEANINGFUL_NAME=$(basename "$(dirname "$TARGET")")
    fi
    echo "  $GENERATION_NUMBER   $GENERATION_DATE   ($MEANINGFUL_NAME)"
done

# Prompt the user to choose a generation
read -p "Enter the generation number you want to pin: " GENERATION

# Check if the specified generation exists (active)
ACTIVE_GENERATION=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | grep "^ *$GENERATION" | wc -l)
if [ "$ACTIVE_GENERATION" -eq "0" ]; then
    # Check if the specified generation exists (inactive)
    INACTIVE_GENERATION=$(ls -1 /nix/var/nix/profiles/system-*-link | grep -oE '[0-9]+' | grep "^ *$GENERATION" | wc -l)
    if [ "$INACTIVE_GENERATION" -eq "0" ]; then
        echo "Error: Generation ${GENERATION} does not exist."
        exit 1
    fi
fi

# Prompt the user to enter a meaningful name
read -p "Enter a meaningful name for this generation: " MEANINGFUL_NAME
LINK_PATH="/nix/var/nix/gcroots/per-user/root/${MEANINGFUL_NAME}"

# Check if a symlink with the same name already exists
if [ -L "$LINK_PATH" ]; then
    echo "Error: A symlink with the name ${MEANINGFUL_NAME} already exists."
    exit 1
fi

# Create the symlink
TARGET_PATH="/nix/var/nix/profiles/system-${GENERATION}"
ln -s "$TARGET_PATH" "$LINK_PATH"

# Verify the link
if [ -L "$LINK_PATH" ]; then
    echo "Successfully pinned generation ${GENERATION} as ${MEANINGFUL_NAME}."
else
    echo "Failed to create symlink."
    exit 1
fi
