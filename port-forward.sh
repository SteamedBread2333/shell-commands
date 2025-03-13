#!/bin/bash
# -----------------------------------------------------------------------------
# File: port-forward.sh
# Description: A script to set up port forwarding using socat.
#              It forwards traffic from a redirect port to a target port.
#              If socat is not installed, it will attempt to install it.
# Usage:       ./port-forward.sh <redirect_port> <target_port>
# Example:     ./port-forward.sh 80 8000
# Dependencies: Requires socat to be installed.
# Compatibility: Designed for Linux and macOS. Windows support via WSL.
# -----------------------------------------------------------------------------

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

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Error: Incorrect number of arguments."
    echo "Usage: $0 <redirect_port> <target_port>"
    exit 1
fi

# Retrieve arguments
redirect_port="$1"
target_port="$2"

# Validate port numbers
if ! [[ "$redirect_port" =~ ^[0-9]+$ ]] || ! [[ "$target_port" =~ ^[0-9]+$ ]]; then
    echo "Error: Port numbers must be valid integers."
    exit 1
fi

if [ "$redirect_port" -lt 1 ] || [ "$redirect_port" -gt 65535 ] || [ "$target_port" -lt 1 ] || [ "$target_port" -gt 65535 ]; then
    echo "Error: Port numbers must be between 1 and 65535."
    exit 1
fi

# Check if socat is installed, and install it if not
if ! command -v socat &> /dev/null; then
    install_socat
fi

# Set up port forwarding
echo "Info: Setting up port forwarding from $redirect_port to $target_port..."
socat TCP-LISTEN:"$redirect_port",fork TCP:127.0.0.1:"$target_port"

# Check if socat started successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to set up port forwarding."
    exit 1
fi

echo "Info: Port forwarding from $redirect_port to $target_port is now active."
echo "Info: Press Ctrl+C to stop the forwarding."

# Keep the script running until the user interrupts
while true; do
    sleep 1
done