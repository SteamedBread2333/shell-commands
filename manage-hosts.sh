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

# Function to display usage information
display_usage() {
    echo "Usage: $0 <action> [<ip> <domain> | <domain>]"
    echo "Actions:"
    echo "  add <ip> <domain>       Add a host entry"
    echo "  remove <domain>         Remove a host entry"
    echo "  remove-all <domain>     Remove all entries for a domain"
    exit 1
}

# Function to add a host entry
add_host() {
    local ip="$1"
    local domain="$2"
    local hosts_path="$3"
    
    # Check if the host entry already exists
    while IFS= read -r line; do
        if [[ "$line" == "$ip $domain" ]]; then
            echo "Warning: Host entry for $domain already exists."
            return
        fi
    done < "$hosts_path"
    
    # Add the host entry
    echo "$ip $domain" | sudo tee -a "$hosts_path" > /dev/null
    echo "Info: Added host entry: $ip $domain"
}

# Function to remove a host entry
remove_host() {
    local domain="$1"
    local hosts_path="$2"
    local temp_file=$(mktemp)
    
    # Check if the host entry exists
    local found=false
    while IFS= read -r line; do
        if [[ "$line" == *" $domain" ]]; then
            found=true
        fi
    done < "$hosts_path"
    
    if [ "$found" = false ]; then
        echo "Warning: No host entry found for $domain."
        return
    fi
    
    # Remove the host entry
    while IFS= read -r line; do
        if [[ "$line" != *" $domain" ]]; then
            echo "$line" >> "$temp_file"
        fi
    done < "$hosts_path"
    
    sudo mv "$temp_file" "$hosts_path"
    echo "Info: Removed host entry for $domain"
}

# Function to remove all entries for a domain
remove_all_hosts_for_domain() {
    local domain_pattern="$1"
    local hosts_path="$2"
    local temp_file=$(mktemp)
    
    # Check if any entries for the domain exist
    local found=false
    while IFS= read -r line; do
        if [[ "$line" == *" $domain_pattern" ]]; then
            found=true
        fi
    done < "$hosts_path"
    
    if [ "$found" = false ]; then
        echo "Warning: No host entries found for domain pattern: $domain_pattern"
        return
    fi
    
    # Remove all entries for the domain
    while IFS= read -r line; do
        if [[ "$line" != *" $domain_pattern" ]]; then
            echo "$line" >> "$temp_file"
        fi
    done < "$hosts_path"
    
    sudo mv "$temp_file" "$hosts_path"
    echo "Info: Removed all host entries for domain pattern: $domain_pattern"
}

# Main function to handle script actions
main() {
    # Check if the correct number of arguments is provided
    if [ $# -lt 1 ]; then
        display_usage
    fi

    local action="$1"
    local ip=""
    local domain=""

    # Determine the action and retrieve arguments
    case "$action" in
        add)
            if [ $# -ne 3 ]; then
                display_usage
            fi
            ip="$2"
            domain="$3"
            ;;
        remove)
            if [ $# -ne 2 ]; then
                display_usage
            fi
            domain="$2"
            ;;
        remove-all)
            if [ $# -ne 2 ]; then
                display_usage
            fi
            domain="$2"
            ;;
        *)
            display_usage
            ;;
    esac

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
    case "$action" in
        add)
            add_host "$ip" "$domain" "$hosts_path"
            ;;
        remove)
            remove_host "$domain" "$hosts_path"
            ;;
        remove-all)
            remove_all_hosts_for_domain "$domain" "$hosts_path"
            ;;
    esac
}

# Execute the main function with the provided arguments
main "$@"