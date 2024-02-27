#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg

# Create a directory for the Docker GPG keyring
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update apt package index
sudo apt-get update

# Install Docker Engine, CLI, and additional tools
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

######webserver#####
sudo apt-get install -y apache2
sudo ufw app list
sudo ufw allow 'Apache'
sudo ufw status
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl status apache2

echo "Apache web server is installed and running"
#####webserver####