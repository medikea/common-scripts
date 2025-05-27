#!/bin/bash

# Exit on error
set -e

# Check if the OS is Ubuntu
if ! grep -q "ID=ubuntu" /etc/os-release; then
    echo "This script is intended for Ubuntu distributions only."
    exit 1
fi

echo "Updating package list..."
sudo apt-get update

echo "Installing required dependencies..."
sudo apt-get install ca-certificates curl

# Download and add Docker's official GPG key:
echo "Adding Docker GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
# Ensure curl command is robust
if ! sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc; then
    echo "Failed to download Docker GPG key. Please check your internet connection or the URL."
    exit 1
fi
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "Installing Docker Engine, CLI, and containerd..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


echo "Adding current user to the Docker group..."
# Create docker group if it doesn't already exist
if ! getent group docker > /dev/null; then
  sudo groupadd docker
  echo "Docker group created."
else
  echo "Docker group already exists."
fi

sudo usermod -aG docker $USER
echo "User $USER added to the docker group."
echo "IMPORTANT: For group changes to take full effect, you need to log out and log back in, or restart your system."
echo "The 'newgrp docker' command below applies the group change only for the current shell session."
newgrp docker

echo "Starting and enabling Docker service..."
# Enable and start services immediately
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service

echo "Installation complete! Run 'docker --version' to check the installation."
echo "Remember to log out and back in or restart your system for group changes to apply permanently."
