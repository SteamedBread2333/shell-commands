#!/bin/bash
# -----------------------------------------------------------------------------
# File: manage-hosts.sh
# Description: A script to manage host entries in the system's hosts file.
#              It supports adding, removing, and removing all entries for a domain.
# Usage:
#   - Add a host entry:       ./manage-hosts.sh add <ip> <domain>
#   - Remove a host entry:    ./manage-hosts.sh remove <domain>
#   - Remove all entries for a domain: ./manage-hosts.sh remove-all <domain>
# Dependencies: Requires sudo privileges to modify the hosts file.
# Compatibility: Designed for Linux and macOS. Windows support via WSL.
# -----------------------------------------------------------------------------

# Function to validate domain format
validate_domain() {
    local domain="$1"
    # Regular expression for domain validation
    local domain_regex="^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$"
    if ! [[ $domain =~ $domain_regex ]]; then
        echo "Error: Invalid domain format."
        return 1
    fi
    return 0
}

# Function to add a host entry
add_host() {
    local ip="$1"
    local domain="$2"
    local hosts_path="$3"
    
    # Validate domain format
    if ! validate_domain "$domain"; then
        return 1
    fi
    
    # Check if the host entry already exists
    if grep -q "$domain" "$hosts_path"; then
        echo "Warning: Host entry for $domain already exists."
        return
    fi
    
    # Add the host entry
    echo "$ip $domain" | sudo tee -a "$hosts_path" > /dev/null
    echo "Info: Added host entry: $ip $domain"
}

# Function to remove a host entry
remove_host() {
    local domain="$1"
    local hosts_path="$2"
    
    # Validate domain format
    if ! validate_domain "$domain"; then
        return 1
    fi
    
    # Check if the host entry exists
    if ! grep -q "$domain" "$hosts_path"; then
        echo "Warning: No host entry found for $domain."
        return
    fi
    
    # Remove the host entry
    sudo sed -i "/$domain/d" "$hosts_path"
    echo "Info: Removed host entry for $domain"
}

# Function to remove all entries for a domain
remove_all_hosts_for_domain() {
    local domain_pattern="$1"
    local hosts_path="$2"
    
    # Validate domain format
    if ! validate_domain "$domain_pattern"; then
        return 1
    fi
    
    # Check if any entries for the domain exist
    if ! grep -q "$domain_pattern" "$hosts_path"; then
        echo "Warning: No host entries found for domain pattern: $domain_pattern"
        return
    fi
    
    # Remove all entries for the domain
    sudo sed -i "/$domain_pattern/d" "$hosts_path"
    echo "Info: Removed all host entries for domain pattern: $domain_pattern"
}

# Main function to handle script actions
main() {
    local action="$1"
    local ip="$2"
    local domain="$3"
    
    # Determine the hosts file path based on the operating system
    local hosts_path=""
    if [[ "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ]]; then
        hosts_path="/etc/hosts"
    elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        hosts_path="C:\Windows\System32\drivers\etc\hosts"
    else
        echo "Error: Unsupported operating system."
        exit 1
    fi
    
    # Execute the requested action
    if [ "$action" == "add" ]; then
        add_host "$ip" "$domain" "$hosts_path"
    elif [ "$action" == "remove" ]; then
        remove_host "$domain" "$hosts_path"
    elif [ "$action" == "remove-all" ]; then
        remove_all_hosts_for_domain "$domain" "$hosts_path"
    else
        echo "Error: Invalid action. Use 'add', 'remove', or 'remove-all'."
        exit 1
    fi
}

# Execute the main function with the provided arguments
main "$@"