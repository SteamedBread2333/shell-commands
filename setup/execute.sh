#!/bin/bash
# -----------------------------------------------------------------------------
# File: main-setup.sh
# Description: This script orchestrates the setup of a frontend development environment
#              by invoking specialized scripts for base tools, development environment
#              configuration, and optional Docker-related packages.
# Usage:       ./main-setup.sh
# Compatibility: GNU bash, version 5.2.15(1)-release (x86_64-apple-darwin20.6.0)
# -----------------------------------------------------------------------------

# Exit on error
set -e

# Define color variables for formatted output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # End of color

# Get the directory of the script
path=$(dirname "$0")

echo -e "${GREEN}Starting frontend development environment setup...${NC}"

# Call the script to install base tools
echo -e "${YELLOW}Installing base tools...${NC}"
source $path/setup-base-tools.sh

# Call the script to configure the development environment
echo -e "${YELLOW}Configuring development environment...${NC}"
source $path/setup-dev-env.sh

# Ask the user if they want to install Docker-related packages
read -p "Would you like to install Docker-related packages? (y/n): " install_docker
if [[ "$install_docker" == "y" || "$install_docker" == "Y" ]]; then
    echo -e "${YELLOW}Installing Docker-related packages...${NC}"
    source $path/setup-docker.sh
else
    echo -e "${YELLOW}Skipping installation of Docker-related packages.${NC}"
fi

echo -e "${GREEN}Frontend development environment setup completed!${NC}"
echo -e "${YELLOW}Please restart your terminal to apply all changes.${NC}"