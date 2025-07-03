#!/bin/bash

# Enable error handling
set -e

# Update system
echo "Updating system packages..."
sudo apt update -y

# Install Java 17
echo "Installing Java 17..."
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y
sudo apt install openjdk-17-jre-headless unzip dos2unix -y

echo "Java version:"
/usr/bin/java --version

# Install Docker
echo "Installing Docker..."
sudo apt-get update
sudo apt-get install docker.io -y
sudo chmod 777 /var/run/docker.sock

# Add users to docker group
sudo usermod -aG docker ubuntu

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

echo "Docker version:"
docker --version

# Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

echo "AWS CLI version:"
aws --version

# Clean up AWS CLI installation files
rm awscliv2.zip
rm -rf aws

# Create a status file to indicate completion
echo "$(date): DevOps tools installation completed successfully" | sudo tee /var/log/devops-setup.log

echo "Installation completed! Services status:"
echo "Docker: $(sudo systemctl is-active docker)"

# To clone the repository
git clone https://github.com/techmahato-com/Netflix-Clone-on-ECS.git