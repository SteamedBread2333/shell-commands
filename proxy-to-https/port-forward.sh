#!/bin/bash
# -----------------------------------------------------------------------------
# File: port-forward.sh
# Description: A script to set up HTTPS to HTTP port forwarding using socat.
#              It forwards traffic from an HTTPS port to an HTTP port.
#              If server.pem is not found, it will attempt to generate it.
# Usage:       ./port-forward.sh <https_port> <http_port>
# Example:     ./port-forward.sh 443 8000
# Dependencies: Requires socat to be installed.
# Compatibility: Designed for Linux and macOS. Windows support via WSL.
# -----------------------------------------------------------------------------

# Function to display usage information
display_usage() {
    echo "Usage: $0 <https_port> <http_port>"
    echo "This script sets up HTTPS to HTTP port forwarding using socat."
    echo "It forwards traffic from an HTTPS port to an HTTP port."
    echo "Example:"
    echo "  ./port-forward.sh 443 8000"
    exit 1
}

# Function to install socat based on the operating system
install_socat() {
    echo "Info: socat is not installed. Attempting to install it now..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux (Debian/Ubuntu)
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y socat
        # Linux (Red Hat/CentOS/Fedora)
        elif command -v yum &> /dev/null; then
            sudo yum install -y socat
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y socat
        else
            echo "Error: Unable to determine package manager. Please install socat manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install socat
        else
            echo "Error: Homebrew is not installed. Please install Homebrew and then run this script again."
            exit 1
        fi
    else
        echo "Error: Unsupported operating system. Please install socat manually."
        exit 1
    fi

    # Check if socat was installed successfully
    if ! command -v socat &> /dev/null; then
        echo "Error: Failed to install socat. Please install it manually."
        exit 1
    fi

    echo "Info: socat has been installed successfully."
}

# Function to check and generate server.pem if needed
generate_server_pem() {
    if [ ! -f "server.pem" ]; then
        echo "Info: server.pem not found. Generating it now..."
        ./generate-server-pem.sh
        if [ $? -ne 0 ]; then
            echo "Error: Failed to generate server.pem. Please check generate-server-pem.sh."
            exit 1
        fi
    fi
}

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    display_usage
fi

# Retrieve arguments
https_port="$1"
http_port="$2"

# Validate port numbers
if ! [[ "$https_port" =~ ^[0-9]+$ ]] || ! [[ "$http_port" =~ ^[0-9]+$ ]]; then
    echo "Error: Port numbers must be valid integers."
    display_usage
fi

if [ "$https_port" -lt 1 ] || [ "$https_port" -gt 65535 ] || [ "$http_port" -lt 1 ] || [ "$http_port" -gt 65535 ]; then
    echo "Error: Port numbers must be between 1 and 65535."
    display_usage
fi

# Check if socat is installed, and install it if not
if ! command -v socat &> /dev/null; then
    install_socat
fi

# Generate server.pem if needed
generate_server_pem

# Set up port forwarding
echo "Info: Setting up HTTPS to HTTP port forwarding from $https_port to $http_port..."
socat -v openssl-listen:"$https_port",reuseaddr,fork,cert=server.pem,verify=0 tcp:127.0.0.1:"$http_port"

# Check if socat started successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to set up port forwarding."
    exit 1
fi

echo "Info: HTTPS to HTTP port forwarding from $https_port to $http_port is now active."
echo "Info: Press Ctrl+C to stop the forwarding."

# Keep the script running until the user interrupts
while true; do
    sleep 1
done