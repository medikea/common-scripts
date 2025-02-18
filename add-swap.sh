#!/bin/bash

# Variables
SWAP_SIZE="1G"  # Change this to the desired swap size
SWAP_FILE="/swapfile"

# Check if swap already exists
if swapon --show | grep -q "$SWAP_FILE"; then
    echo "Swap space already exists. Exiting."
    exit 0
fi

# Create a swap file
sudo fallocate -l $SWAP_SIZE $SWAP_FILE
if [ $? -ne 0 ]; then
    echo "Failed to allocate swap file. Exiting."
    exit 1
fi

# Set the correct permissions
sudo chmod 600 $SWAP_FILE

# Set up the swap space
sudo mkswap $SWAP_FILE

# Enable the swap file
sudo swapon $SWAP_FILE

# Make swap permanent by adding it to /etc/fstab
if ! grep -q "$SWAP_FILE" /etc/fstab; then
    echo "$SWAP_FILE none swap sw 0 0" | sudo tee -a /etc/fstab
fi

# Adjust swappiness (optional, default is 60)
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Adjust cache pressure (optional)
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Confirm the swap space is active
swapon --show
free -h

echo "Swap space of $SWAP_SIZE added successfully."
