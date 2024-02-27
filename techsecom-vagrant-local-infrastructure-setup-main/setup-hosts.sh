#!/bin/bash
set -e
# Function to find an available network device
find_available_network_device() {
    # List all network devices and filter out lo (loopback) and docker interfaces
    for device in $(ls /sys/class/net | grep -vE 'lo|docker'); do
        echo "Available network device found: $device"
        return 0
    done

    # No suitable device found
    echo "No available network device found."
    return 1
}

# Check if the network device enp0s8 exists
if ip link show enp0s8 > /dev/null 2>&1; then
    echo "Network device enp0s8 exists. Proceeding with configuration."
    # Your existing configuration commands go here
else
    echo "Network device enp0s8 does not exist. Checking for available devices..."
    find_available_network_device
fi

IFNAME=$1
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-bionic entry
sed -e '/^.*ubuntu-bionic.*/d' -i /etc/hosts

# Update /etc/hosts about other hosts
cat >> /etc/hosts <<EOF
192.168.5.11  master-1
192.168.5.12  master-2
192.168.5.13  master-3
192.168.5.21  worker-1
192.168.5.22  worker-2
192.168.5.23  worker-3
192.168.5.24  worker-4
192.168.5.25  worker-5
192.168.5.26  worker-6
192.168.5.30  lb
EOF