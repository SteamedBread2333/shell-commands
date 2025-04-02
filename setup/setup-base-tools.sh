#!/bin/bash
# -----------------------------------------------------------------------------
# File: setup-base-tools.sh
# Description: This script installs essential development tools and applications
#              required for a basic development setup on macOS.
# Usage:       source ./setup-base-tools.sh
# Compatibility: GNU bash, version 5.2.15(1)-release (x86_64-apple-darwin20.6.0)
# -----------------------------------------------------------------------------

# Exit on error
set -e

# Define color variables for formatted output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting installation of base tools...${NC}"

# Check if Homebrew is installed; if not, install it
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew not detected, installing...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo -e "${GREEN}Homebrew installation completed!${NC}"
else
    echo -e "${GREEN}Homebrew is installed, updating...${NC}"
    brew update
fi

# Install common development tools
echo -e "${GREEN}Installing common development tools...${NC}"
# Git: Version control system for code management
brew install git
# Yarn: JavaScript package manager for installing and managing project dependencies
brew install yarn
# Zsh: Alternative command-line shell with enhanced features
brew install zsh
# Tmux: Terminal multiplexer for running multiple terminal sessions in one window
brew install tmux
# Wget: Command-line download tool for retrieving files from the web
brew install wget
# Curl: Command-line tool for making network requests
brew install curl

# Install VS Code
echo -e "${GREEN}Installing VS Code...${NC}"
# Visual Studio Code: Popular code editor supporting multiple programming languages and plugins
brew install --cask visual-studio-code

# Install Google Chrome
echo -e "${GREEN}Installing Google Chrome...${NC}"
# Google Chrome: Popular web browser for testing and debugging web applications
brew install --cask google-chrome

# Install Firefox
echo -e "${GREEN}Installing Firefox...${NC}"
# Firefox: Another popular web browser for testing and debugging web applications
brew install --cask firefox

# Install Postman
echo -e "${GREEN}Installing Postman...${NC}"
# Postman: API testing tool for sending HTTP requests and testing APIs
brew install --cask postman

# Install Oh My Zsh (optional)
echo -e "${GREEN}Installing Oh My Zsh...${NC}"
# Oh My Zsh: Zsh extension framework with many pre-configured themes and plugins
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo -e "${GREEN}Base tools installation completed!${NC}"