#!/bin/bash

set -e

# Detect OS
OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
fi

echo "Detected OS: $OS"

# Install Git
echo "Installing Git..."
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    sudo apt update -y
    sudo apt install -y git
elif [[ "$OS" == "amzn" || "$OS" == "centos" || "$OS" == "rhel" ]]; then
    sudo yum install -y git
else
    echo "Unsupported OS for Git install: $OS"
    exit 1
fi

# Install Docker
echo "Installing Docker..."
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    sudo apt update -y
    sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update -y
    sudo apt install -y docker-ce
elif [[ "$OS" == "amzn" || "$OS" == "centos" || "$OS" == "rhel" ]]; then
    sudo yum install -y docker
else
    echo "Unsupported OS for Docker install: $OS"
    exit 1
fi

# Start and Enable Docker
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to Docker group
echo "Adding user '$USER' to docker group..."
sudo usermod -aG docker $USER

# Install Docker Compose v1
echo "Installing Docker Compose v1..."
COMPOSE_URL="https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)"
sudo curl -L "$COMPOSE_URL" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Optional symlink
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# Show versions
echo
docker --version
docker-compose --version
git --version

echo "Git, Docker, and Docker Compose v1 installation complete!"
echo "You may need to log out and back in to use Docker without sudo."

# Preparation for using Docker containers
echo "Cloning ContainYourself repository..."
mkdir -p ~/containers
git clone --branch main https://github.com/LamSut/ContainYourself.git ~/containers
echo "Now you can play with containers!"
