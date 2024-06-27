#!/bin/bash
# Tolga Erok
# Delete generations @ user choice

# List generations
echo "Listing all generations for profile /nix/var/nix/profiles/system:"
nix-env --list-generations --profile /nix/var/nix/profiles/system

# Get the current generation
current_gen=$(readlink -f /nix/var/nix/profiles/system | grep -oE '[0-9]+$')

echo "Current generation: $current_gen"

# Pause to allow user to review the list
read -p "Press Enter to continue..."

# Ask the user which generations to delete
read -p "Enter the generations you want to delete (separated by space): " -a generations_to_delete

# Remove the current generation from the list if it is included
generations_to_delete=("${generations_to_delete[@]/$current_gen}")

# Ensure at least one generation is left (excluding the current one)
if [[ ${#generations_to_delete[@]} -ge $(($(nix-env --list-generations --profile /nix/var/nix/profiles/system | wc -l) - 1)) ]]; then
    echo "You must leave at least one generation. Deletion cancelled."
    exit 1
fi

# Confirm deletion
echo "You are about to delete the following generations: ${generations_to_delete[*]}"
read -p "Are you sure? (y/N): " confirmation

if [[ $confirmation == [yY] || $confirmation == [yY][eE][sS] ]]; then
    # Delete the specified generations
    for gen in "${generations_to_delete[@]}"; do
        nix-env --delete-generations --profile /nix/var/nix/profiles/system $gen
        if [ $? -eq 0 ]; then
            echo "Generation $gen deleted successfully."
        else
            echo "Failed to delete generation $gen."
        fi
    done

    # Run garbage collection to free up disk space
    nix-collect-garbage
    echo "Garbage collection completed."

    # Rebuild the boot configuration
    echo "Updating boot configuration..."
    sudo nixos-rebuild boot
else
    echo "Deletion cancelled."
fi
