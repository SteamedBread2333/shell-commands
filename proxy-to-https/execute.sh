#!/bin/bash
# -----------------------------------------------------------------------------
# File: execute.sh
# Description:  This script generates a self-signed certificate for a given domain.
# Usage:        ./execute.sh <domain>
# Compatibility: GNU bash, version 5.2.15(1)-release (x86_64-pc-linux-gnu)
# -----------------------------------------------------------------------------

# Retrieve arguments
domain="$1"

# Get the directory of the script
path=$(dirname "$0")

$path/manage-hosts.sh add 127.0.0.1 "$domain"

$path/port-forward.sh 443 8000
# ./port-forward.sh 80 8000

# Function to be executed when Ctrl+C is pressed
callback() {
  $path/manage-hosts.sh remove "$domain"
  # chmod -x ./*
  trap - SIGINT
  trap - EXIT
}

# Set the trap for SIGINT (Ctrl+C) and EXIT signals
trap callback SIGINT
trap callback EXIT
