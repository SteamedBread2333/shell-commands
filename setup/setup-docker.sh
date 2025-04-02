#!/bin/bash
# -----------------------------------------------------------------------------
# File: setup-docker.sh
# Description: This script installs Docker-related packages, including Docker,
#              Docker Desktop, and Insomnia for API testing.
# Usage:       source ./setup-docker.sh
# Compatibility: GNU bash, version 5.2.15(1)-release (x86_64-apple-darwin20.6.0)
# -----------------------------------------------------------------------------

# Exit on error
set -e

# Define color variables for formatted output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting installation of Docker-related packages...${NC}"

# Install Docker-related packages
echo -e "${GREEN}Installing Docker-related packages...${NC}"
# Docker: Containerization platform for developing, deploying, and running applications
brew install --cask docker
# Docker Desktop: Desktop version of Docker for simplified container management
brew install --cask docker-desktop
# Docker Edge: Test version of Docker with the latest features
brew install --cask docker-edge
# Insomnia: API client for sending HTTP requests and testing APIs
brew install --cask insomnia

echo -e "${GREEN}Docker-related packages installation completed!${NC}"