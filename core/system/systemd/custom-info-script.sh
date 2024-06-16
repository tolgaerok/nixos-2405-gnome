#!/run/current-system/sw/bin/sh
# Tolga Erok

# Set PATH to include the necessary command directories
export PATH="/run/current-system/sw/bin:$PATH"

# Optionally allow insecure downloads if needed
export NIXPKGS_ALLOW_INSECURE=1

# Ensure flatpak is in the PATH if pkgs.flatpak is defined
# export PATH=${pkgs.flatpak}/bin:$PATH

# Set permissions to 777 for all files and directories under /etc/nixos
sudo chmod -R 777 /etc/nixos
sudo chmod +x /etc/nixos/*

# Add Flathub repository
if flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo; then
    echo -e "\n\e[1;32m\\\\_(ツ)_/¯ \e[0m Flathub repo added and configured successfully ==>  \e[1;32m[✔]\e[0m "
else
    echo -e "\e[1;31m\\\\_(ツ)_/¯ \e[0m Error: Failed to configure Flathub repo ==>  \e[1;31m[✘]\e[0m "
    exit 1 # Exit with an error code to indicate failure
fi

# Fetch RAM information
RAM_INSTALLED=$(free -h | awk '/^Mem/ {print $2}')
RAM_USED=$(free -h | awk '/^Mem/ {print $3}')

# Fetch and filter tmpfs information from df
TMPFS_USED=$(df -h | grep tmpfs)

# Fetch zramswap information
ZRAMSWAP_USED=$(zramctl | grep /dev/zram0 | awk '{print $4}')

# Fetch earlyoom information
EARLYOOM_STATUS=$(pgrep earlyoom >/dev/null && echo -e "\e[32mRunning\e[34m" || echo -e "\e[31mNot Running\e[34m")

# Check if the service is active
if systemctl --quiet is-active configure-flathub-repo.service; then
    FLATHUB_ACTIVE="\e[32mActive\e[0m"
else
    FLATHUB_ACTIVE="\e[33mInactive\e[0m"
fi

# Check if the service is enabled
if systemctl is-enabled configure-flathub-repo.service >/dev/null; then
    FLATHUB_LOADED="\e[32mLoaded\e[0m"
else
    FLATHUB_LOADED="\e[33mNot Loaded\e[0m"
fi

# Restarting kernel tweaks
echo -e "\e[1;32m[✔]\e[0m Restarting kernel tweaks...\n"
sudo sysctl --system
sleep 1

# Print descriptions in yellow and results in blue
printf "\n\e[33mRAM Installed:\e[0m %s\n" "$RAM_INSTALLED"
printf "\e[33mRAM Used:\e[0m %s\n" "$RAM_USED"
printf "\n\e[33mDisk space and TMPFS Used:\e[0m\n%s\n" "$TMPFS_USED"
printf "\n\e[33mZRAMSWAP Used:\e[0m %s\n" "$ZRAMSWAP_USED"
printf "\e[33mEarlyoom Status:\e[0m %s\n" "$EARLYOOM_STATUS"
echo -e "\nFlathub Service Status: $FLATHUB_ACTIVE / $FLATHUB_LOADED"

# lfs
duf
figlet system updated
# espeak -v en+m7 -s 165 "system! up! dated!  kernel! tweaks! applied!" --punct="," 2>/dev/null
