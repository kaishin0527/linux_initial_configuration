


#!/bin/bash

# Main installation script that combines setup and post-installation
# This script runs the main setup and then the post-installation tasks

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Check if setup.sh exists
if [ ! -f "setup.sh" ]; then
    echo "Error: setup.sh not found in current directory"
    exit 1
fi

# Check if post-install.sh exists
if [ ! -f "post-install.sh" ]; then
    echo "Error: post-install.sh not found in current directory"
    exit 1
fi

print_status "Starting Linux Initial Configuration Installation..."
print_status "This will install and configure zsh, peco, autojump, and other tools"
print_status "Press Enter to continue or Ctrl+C to cancel..."
read

# Run the main setup script
print_status "Running main setup script..."
./setup.sh

# Run the post-installation script
print_status "Running post-installation tasks..."
./post-install.sh

print_success "Installation completed successfully!"
print_status "Your Linux environment is now configured with:"
echo "  - Zsh with Powerlevel10k theme"
echo "  - Peco for enhanced command selection"
echo "  - Autojump for smart directory navigation"
echo "  - Essential development tools"
echo "  - Custom aliases and functions"
echo ""
print_status "Please restart your terminal or run 'source ~/.zshrc' to apply all changes."


