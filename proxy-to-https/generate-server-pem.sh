#!/bin/bash
# -----------------------------------------------------------------------------
# File: generate-server-pem.sh
# Description: A script to generate a self-signed SSL certificate (server.pem).
#              If openssl is not installed, it will attempt to install it.
# Usage:        ./generate-server-pem.sh
# Compatibility: Designed for Linux and macOS. Windows support via WSL.
# -----------------------------------------------------------------------------

# Function to display usage information
display_usage() {
    echo "Usage: $0"
    echo "This script generates a self-signed SSL certificate (server.pem)."
    echo "If openssl is not installed, it will attempt to install it."
    echo "Example:"
    echo "  ./generate-server-pem.sh"
    exit 1
}

# Function to install openssl based on the operating system
install_openssl() {
    echo "Info: openssl is not installed. Attempting to install it now..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux (Debian/Ubuntu)
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y openssl
        # Linux (Red Hat/CentOS/Fedora)
        elif command -v yum &> /dev/null; then
            sudo yum install -y openssl
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y openssl
        else
            echo "Error: Unable to determine package manager. Please install openssl manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install openssl
        else
            echo "Error: Homebrew is not installed. Please install Homebrew and then run this script again."
            exit 1
        fi
    else
        echo "Error: Unsupported operating system. Please install openssl manually."
        exit 1
    fi

    # Check if openssl was installed successfully
    if ! command -v openssl &> /dev/null; then
        echo "Error: Failed to install openssl. Please install it manually."
        exit 1
    fi

    echo "Info: openssl has been installed successfully."
}

# Define the output file name
OUTPUT_FILE="server.pem"

# Check if the output file already exists
if [ -f "$OUTPUT_FILE" ]; then
    echo "Error: $OUTPUT_FILE already exists. Please delete it or choose a different name."
    exit 1
fi

# Check if openssl is installed, and install it if not
if ! command -v openssl &> /dev/null; then
    install_openssl
fi

# Generate a private key
echo "Info: Generating private key (server.key)..."
if ! openssl genrsa -out server.key 4096; then
    echo "Error: Failed to generate private key."
    exit 1
fi

# Generate a self-signed certificate
echo "Info: Generating self-signed certificate (server.crt)..."
# The -subj option sets the subject of the certificate, which is the domain name of the server.
# The -days option sets the number of days the certificate is valid for.
# The -out option specifies the output file name.
# The -key option specifies the private key file name.
# The -x509 option specifies that the certificate should be self-signed.
if ! openssl req -new -key server.key -x509 -days 3653 -out server.crt -subj "/CN=portal-content-nexus-uat.derbysoft-test.com"; then
    echo "Error: Failed to generate self-signed certificate."
    rm server.key
    exit 1
fi

# Combine the private key and certificate into a single PEM file
echo "Info: Combining private key and certificate into $OUTPUT_FILE..."
if ! cat server.key server.crt > "$OUTPUT_FILE"; then
    echo "Error: Failed to combine key and certificate."
    rm server.key server.crt
    exit 1
fi

# Clean up intermediate files
echo "Info: Cleaning up intermediate files..."
if ! rm server.key server.crt; then
    echo "Warning: Failed to remove intermediate files."
fi

# Check if the PEM file was created successfully
if [ -f "$OUTPUT_FILE" ]; then
    echo "Info: Successfully generated $OUTPUT_FILE."
else
    echo "Error: Failed to generate $OUTPUT_FILE."
    exit 1
fi