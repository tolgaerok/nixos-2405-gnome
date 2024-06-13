#!/usr/bin/env bash

apply_cake_qdisc() {
    local interface="$1"
    echo "Configuring interface $interface..."
    if sudo tc qdisc replace dev "$interface" root cake bandwidth 1Gbit; then
        echo "Successfully configured CAKE qdisc on $interface."
    else
        echo "Failed to configure CAKE qdisc on $interface."
        exit 1  # Exit with non-zero status to indicate failure
    fi
}

# Get list of interfaces excluding loopback, virtual, and docker interfaces
interfaces=$(ip link show | awk -F: '$0 !~ "lo|virbr|docker|^[^0-9]"{print $2;getline}')

# Apply CAKE qdisc on each interface
for interface in $interfaces; do
    apply_cake_qdisc "$interface"
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
    echo "Verifying qdisc configuration for $interface:"
    qdisc_output=$(sudo tc qdisc show dev "$interface")
    if echo "$qdisc_output" | grep -q 'cake'; then
        echo "CAKE qdisc is active on $interface."
    else
        echo "CAKE qdisc is NOT active on $interface."
    fi
    echo "$qdisc_output"
done

# Exit with success status
exit 0
