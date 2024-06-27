<div align="center">
  <h1 style="font-size: 24px; color: blue;">My NixOs 24.05 GNOME Environment</h1>
  
</div>


![image](https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/1d8a24e0-a126-4045-b6ef-a85be85cee97)


<div align="center">
  
  <h4 style="font-size: 22px; color: blue;">Folio 9470M Laptop </h1>
</div>

</div>

# NixOS Configuration for HP EliteBook Folio 9470m

**Author:** Tolga Erok  
**Date:** 10-6-2024  

This configuration is designed for the HP EliteBook Folio 9470m, optimized for Intel-based laptops with similar specifications. It provides a comprehensive setup including GNOME as the desktop environment, performance tweaks, power-saving configurations, and essential services. 

### Key Features

1. **System Configuration**:
   - **Kernel**: Zen kernel for better performance.
   - **Locale**: Can be set to user specific location
   - **Hostname**: Can be set to user specific liking

2. **Bootloader**:
   - Systemd-boot with EFI support.
   - Plymouth boot splash screen with "breeze" theme.
   - Silent boot with verbose initrd disabled.

3. **Filesystem**:
   - Uses tmpfs for `/run` and `/tmp` for better performance.
   - Bind mounts for `DLNA`, `MyGit`, and `Universal` directories.

4. **Services**:
   - OpenSSH for remote access.
   - Printing support via CUPS.
   - Power-saving configurations for PCI and USB devices.
   - Automatic network management with NetworkManager.

5. **Systemd Services**:
   - Custom services for bind mounts and ensuring correct directory ownership.
   - Optimizations for I/O scheduler and system resources.

6. **Security and Networking**:
   - Simultaneous multithreading enabled.
   - Network MTU settings optimized.
   - Permit use of certain insecure packages.

7. **User Configuration**:
   - Can use custom user varible with various group memberships for access to different system features.
   - Essential software packages including Firefox, GIMP, Docker, and VSCode.

8. **Graphical Interface**:
   - GNOME desktop environment with extensions like Dash to Dock and Blur My Shell.
   - PipeWire for sound management, replacing PulseAudio.


## Key Features:

- **Optimized Boot Process:** Utilizes systemd-boot with a Plymouth boot splash for a smooth and visually appealing boot experience.
- **Custom Kernel:** Incorporates a custom Linux kernel with specific optimizations and feature enhancements for improved hardware compatibility and performance.
- **Power Management:** Implements various power-saving measures to extend battery life and reduce energy consumption, including CPU and GPU power management options.
- **I/O Scheduler:** Enhances disk I/O performance with the Kyber I/O scheduler and fine-tuned kernel parameters.
- **Security and Privacy:** Disables certain security mitigations for potential performance gains while maintaining system integrity.
- **User-Friendly Configurations:** Sets up user accounts, directories, and permissions for convenience and security.
- **Networking and Locale:** Configures network settings and locale preferences for seamless connectivity and internationalization.
- **Audio and Graphics:** Enhances audio support with Pipewire and optimizes Intel HD Graphics for smoother multimedia playback and gaming experiences.
- **System Services:** Enables and configures essential system services like SSH, printing, and time synchronization for seamless functionality.

## Additional Optimizations:

- **Temporary File Systems:** Utilizes tmpfs for critical system directories to minimize disk I/O and improve responsiveness.
- **Garbage Collection:** Automates garbage collection to maintain efficient disk usage and system performance.
- **Kernel Module Configuration:** Loads and configures specific kernel modules for optimal hardware support and performance.
- **Environmental Settings:** Sets up environmental variables, session managers, and proxy configurations for enhanced usability and compatibility.
- **X11 Settings:** Enables the X11 windowing system with customized keymap configurations for improved user interaction.



### Instructions

1. **Prerequisites**:
   - Ensure your system is compatible with NixOS and the Zen kernel (kernel can be changed to user liking).

2. **Setup**:
   - Copy the provided configuration to your NixOS setup.
   - Adjust user-specific paths and settings as needed.

3. **Installation**:
   - Follow the NixOS installation guide to set up the system with this configuration file.
   - Rebuild the system using `sudo nixos-rebuild switch`.

### Summary

This configuration is tailored to enhance the performance and usability of my HP EliteBook Folio 9470m. It includes optimizations for power-saving, a smooth boot process, and a rich set of user applications and services to provide a robust and efficient Linux experience.

#
# Custom hand coded scripts made for user convienence


### my-nix
- Quick access to the most commonly used nixos commands:

![image](https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/be091c29-b0a4-43bf-aa96-7a7c685effd0)

- In terminal, type:
```bash
my-nix
```
#
### nixos-cake

<div align="center">
  <img src="https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/c10232ae-f06d-4ab4-ae31-2b35f9f4d25a" alt="image2" width="100%">
</div>

- In terminal, type:

```bash
nixos-cake
```

### Script Overview:
The script automatically configures a network optimization tool called CAKE on network interfaces in NixOS. It does the following:

1. **Identifies Interfaces**: Finds active network interfaces excluding the loopback interface.

2. **Applies CAKE**: Sets up CAKE on each active interface, ensuring fair and efficient data transmission.

3. **Updates System Settings**: Adjusts system settings to make CAKE the default queuing system for all new connections.

4. **Checks Configuration**: Confirms that CAKE is correctly configured on each interface.

### CAKE Overview:
CAKE is a network optimization tool known for its simplicity, fairness, and low latency benefits.

#### Pros:
- **Low Latency**: Prioritizes fast response times, ideal for real-time applications.
- **Fairness**: Ensures equal sharing of bandwidth among different connections.
- **Ease of Use**: Simple to configure compared to other similar tools.
- **Effective for All Traffic**: Works well for both uploading and downloading data.

#### Cons:
- **Resource Intensive**: Requires some processing power.
- **Configuration Complexity**: May need some networking knowledge to configure properly.
- **Not for Every Situation**: While generally beneficial, it may not suit every network setup.

### Conclusion:
The script makes network optimization easy by deploying CAKE on NixOS systems, providing faster, fairer data transmission. While CAKE offers many benefits, users should consider their network needs before implementing it.


#
### gitup

<div align="center">
  <img src="https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/f387884a-82dd-4ab4-adb3-f76ee447aa7c" alt="image2" width="45%">
  <img src="https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/b5e75a9f-45c4-4ce7-9b32-7776757c9877" alt="image1" width="45%">
  <img src="https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/3f617ad1-e5cf-40ce-9a73-15c32a1bf91f" alt="image2" width="45%">
</div>

- In terminal, type:
```bash
gitup
```

### Script Overview:
This script automates the process of uploading changes from a NixOS configuration directory to a remote Git repository. It includes:

1. **Setting Up Git Tweaks**: Configures Git settings for better performance and efficiency.
2. **Checking Remote URL**: Verifies if the remote repository is configured for SSH authentication.
3. **Preparing Changes**: Adds all changes in the NixOS configuration directory for commit.
4. **Committing Changes**: Commits changes with a custom message including a timestamp.
5. **Synchronizing with Remote**: Pulls changes from the remote repository to avoid conflicts and pushes changes to the main branch.

### Important Highlights:
- **SSH Authentication**: The script checks if the remote repository is set up for SSH authentication, which is recommended for secure communication.
- **Custom Commit Message**: Each commit includes a timestamp and a custom message indicating the changes made.
- **Efficient Git Configuration**: Configures Git with tweaks for better compression, caching, and delta handling.
- **Synchronization**: Pulls changes from the remote repository before pushing to avoid conflicts and ensure the latest changes are incorporated.

### Conclusion:
This script helps manage NixOS configurations by easily syncing changes to a remote Git repository. It encourages good version control practices for NixOS setups.

#
### Rygel and DLNA installed and configured
- Stream music or media files from your nixos platform easily as Ive configured and made DLNA and rygel to make this possible
<div align="center">
<img src="https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/9c556ec2-dae7-414b-93ab-4a139960e85e" alt="Screenshot" width="35%">
<img src="https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/ff3784a8-57f7-4c09-969d-ef5880652451" alt="Screenshot" width="35%">
  <img src="https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/9b05712f-a5c2-4271-9bc1-97599756e532" alt="Screenshot" width="75%">
<img src="https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/115ceb58-e91e-4734-8ec8-774f61857f4c" alt="Screenshot" width="75%">

</div>

- In terminal, type && enable rygel:

```bash
rygel-preferences 
```
#
### unmounter
- Quickly unmount your custom mnt point's


<div align="center">
  <img src="https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/be5e9bf0-75f4-41e4-97c0-8f1cc5d27448" alt="image1" width="45%">
  <img src="https://github.com/tolgaerok/nixos-2405-gnome/assets/110285959/1528cfe6-77d5-4886-8d36-5bb949832a91" alt="image2" width="45%">
</div>


- In terminal, type:
```bash
unmounter
```
#

<div align="center">
  <table style="border-collapse: collapse; width: 100%; border: none;">
    <tr>
     <td align="center" style="border: none;">
        <a href="https://github.com/tolgaerok/fedora-tolga">
          <img src="https://flathub.org/img/distro/fedora.svg" alt="Fedora" style="width: 100%;">
          <br>Fedora
        </a>
      </td>
      <td align="center" style="border: none;">
        <a href="https://github.com/tolgaerok/Debian-tolga">
          <img src="https://flathub.org/img/distro/debian.svg" alt="Debian" style="width: 100%;">
          <br>Debian
        </a>
      </td>
    </tr>
  </table>
</div>

## *My Stats:*

<div align="center">

<div style="text-align: center;">
  <a href="https://git.io/streak-stats" target="_blank">
    <img src="http://github-readme-streak-stats.herokuapp.com?user=tolgaerok&theme=dark&background=000000" alt="GitHub Streak" style="display: block; margin: 0 auto;">
  </a>
  <div style="text-align: center;">
    <a href="https://github.com/anuraghazra/github-readme-stats" target="_blank">
      <img src="https://github-readme-stats.vercel.app/api/top-langs/?username=tolgaerok&layout=compact&theme=vision-friendly-dark" alt="Top Languages" style="display: block; margin: 0 auto;">
    </a>
  </div>
</div>
</div>
</div>
</div>

Back to [Index](#index)
# nixos-2405-gnome
NIXOS 24.05 GNOME #

