#!/bin/bash

# Auto install Docker Engine on Ubuntu
# Version: 1.0
# Author: Cline

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Step 1: Uninstall old versions
echo "Uninstalling old Docker versions..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  apt-get remove -y $pkg || true
done

# Step 2: Set up Docker's apt repository
echo "Setting up Docker's apt repository..."
# Install prerequisites
apt-get update
apt-get install -y ca-certificates curl

# Create keyring directory
install -m 0755 -d /etc/apt/keyrings

# Add Docker's official GPG key using mirror
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
apt-get update

# Step 3: Install Docker packages
echo "Installing Docker Engine..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 4: Post-installation steps
echo "Configuring Docker for non-root users..."
# Create docker group if it doesn't exist
groupadd docker || true

# Add current user to docker group
if [ -n "$SUDO_USER" ]; then
  usermod -aG docker $SUDO_USER
  echo "User $SUDO_USER added to docker group"
else
  echo "Warning: Could not determine non-root user to add to docker group"
fi

# Step 5: Verify installation
echo "Verifying Docker installation..."
docker run --rm hello-world

echo ""
echo "Docker installation completed successfully!"
echo "Note: You may need to log out and back in for group changes to take effect."
