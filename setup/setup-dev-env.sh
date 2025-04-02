#!/bin/bash
# -----------------------------------------------------------------------------
# File: setup-dev-env.sh
# Description: This script configures the development environment by installing
#              Node.js versions, configuring nvm, and installing VS Code extensions.
# Usage:       source ./setup-dev-env.sh
# Compatibility: GNU bash, version 5.2.15(1)-release (x86_64-apple-darwin20.6.0)
# -----------------------------------------------------------------------------

# Exit on error
set -e

# Define color variables for formatted output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting development environment setup...${NC}"

# Install nvm using the official script
echo -e "${GREEN}Installing nvm using the official script...${NC}"
# nvm: Node.js version management tool for installing and switching between multiple Node.js versions
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Configure nvm environment variables
echo -e "${GREEN}Configuring nvm environment variables...${NC}"
# Set nvm installation path
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# Load nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Add nvm configuration to bash_profile and zshrc
echo "export NVM_DIR=\"$([ -z \"\${XDG_CONFIG_HOME-}\" ] && printf %s \"\${HOME}/.nvm\" || printf %s \"\${XDG_CONFIG_HOME}/nvm\")\"" >>~/.bash_profile
echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\" # This loads nvm" >>~/.bash_profile
echo "[ -s \"\$NVM_DIR/bash_completion\" ] && \\. \"\$NVM_DIR/bash_completion\" # This loads nvm bash_completion" >>~/.bash_profile

echo "export NVM_DIR=\"$([ -z \"\${XDG_CONFIG_HOME-}\" ] && printf %s \"\${HOME}/.nvm\" || printf %s \"\${XDG_CONFIG_HOME}/nvm\")\"" >>~/.zshrc
echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\" # This loads nvm" >>~/.zshrc
echo "[ -s \"\$NVM_DIR/bash_completion\" ] && \\. \"\$NVM_DIR/bash_completion\" # This loads nvm bash_completion" >>~/.zshrc

# Install multiple Node.js versions
echo -e "${GREEN}Installing multiple Node.js versions...${NC}"
# Node.js 14.x: Long-term support version suitable for stable projects
nvm install 14
# Node.js 16.x: Current stable version suitable for most projects
nvm install 16
# Node.js 18.x
nvm install 18
# Node.js 20.x
nvm install 20

# Set default Node.js version
echo -e "${GREEN}Setting default Node.js version to 16...${NC}"
nvm alias default 16

# Function to check if VS Code is installed
check_vscode_installed() {
  if ! command -v code &>/dev/null; then
    echo -e "${RED}VS Code is not installed. Please install VS Code first.${NC}"
    return 1
  fi
  return 0
}

if check_vscode_installed; then
  # Install VS Code extensions (optional)
  echo -e "${GREEN}Installing VS Code extensions...${NC}"
  # ESLint: Code analysis tool for identifying and fixing issues in JavaScript code
  code --install-extension dbaeumer.vscode-eslint
  # Prettier: Code formatting tool for maintaining consistent code style
  code --install-extension esbenp.prettier-vscode
  # Path Intellisense: Path autocompletion for efficient file path input
  code --install-extension christian-kohler.path-intellisense
  # EditorConfig: Tool for maintaining consistent code formatting settings
  code --install-extension editorconfig.editorconfig
  # VS Code ESLint: ESLint plugin for VS Code
  code --install-extension dbaeumer.vscode-eslint
  # TypeScript and TSLint plugins: Support for TypeScript development and code analysis
  code --install-extension ms-vscode.vscode-typescript-tslint-plugin
  # Material Icon Theme: Aesthetic icon theme for VS Code
  code --install-extension PKief.material-icon-theme
  # Material Theme: Aesthetic theme for VS Code
  code --install-extension equinusocio.vsc-material-theme
else
  echo -e "${YELLOW}Skipping installation of VS Code extensions.${NC}"
fi

echo -e "${GREEN}Development environment setup completed!${NC}"
