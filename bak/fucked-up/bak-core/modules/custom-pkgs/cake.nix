{ config, pkgs, ... }:

let

  nixos-cake = pkgs.writeScriptBin "nixos-cake" ''
    #!/usr/bin/env bash
    # Tolga Erok
    # 11-06-2024

    apply_cake_qdisc() {
        local interface="$1"
        echo "Configuring interface $interface..."
        if sudo tc qdisc replace dev "$interface" root cake bandwidth 1Gbit; then
            echo "Successfully configured CAKE qdisc on $interface."
        else
            echo "Failed to configure CAKE qdisc on $interface."
            return 1  # Return non-zero status to indicate failure
        fi
    }

    # Get list of interfaces excluding loopback
    interfaces=$(ip link show | awk -F': ' '/state UP/{print $2}')

    echo ""
    echo "Filtered interfaces: $interfaces"
    echo ""

    # Apply CAKE qdisc on each interface
    for interface in $interfaces; do
        apply_cake_qdisc "$interface" || echo "Failed to apply CAKE to $interface"
    done

    # Update sysctl.conf if necessary
    sysctl_conf="/etc/sysctl.conf"
    if ! grep -qxF 'net.core.default_qdisc = cake' "$sysctl_conf"; then
        echo 'net.core.default_qdisc = cake' | sudo tee -a "$sysctl_conf"
        echo "Added net.core.default_qdisc = cake to $sysctl_conf."
        sudo sysctl -p
    fi

    # Verify qdisc configuration for each interface
    for interface in $interfaces; do
        echo "----------------------------------------------"
        echo "Verifying qdisc configuration for $interface: "
        echo "----------------------------------------------"
        qdisc_output=$(sudo tc qdisc show dev "$interface")
        if echo "$qdisc_output" | grep -q 'cake'; then
            echo "___________________________________"
            echo "CAKE qdisc is active on $interface."
        else
            echo ""
            echo "CAKE qdisc is NOT active on $interface."
        fi
        echo "$qdisc_output"
    done

    sudo sysctl -p

    # Exit with success status
    exit 0

  '';
in
{

  #---------------------------------------------------------------------
  # Type: nixos-cake in terminal to execute above bash script
  #---------------------------------------------------------------------

  environment.systemPackages = [ nixos-cake ];
}
