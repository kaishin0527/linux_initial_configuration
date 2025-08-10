
#!/bin/sh

# Linux Initial Configuration Setup Script
# This script checks for required tools and sets up zsh configuration

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a package is installed
is_package_installed() {
    dpkg -l "$1" >/dev/null 2>&1
}

# Function to install package if not installed
ensure_package() {
    local package=$1
    if ! is_package_installed "$package"; then
        print_status "Installing $package..."
        sudo apt-get update
        sudo apt-get install -y "$package"
        print_success "$package installed successfully"
    else
        print_success "$package is already installed"
    fi
}

# Function to install autojump if not installed
install_autojump() {
    if ! command_exists autojump; then
        print_status "Installing autojump..."
        sudo apt-get update
        sudo apt-get install -y autojump
        print_success "autojump installed successfully"
    else
        print_success "autojump is already installed"
    fi
}

# Function to install peco if not installed
install_peco() {
    if ! command_exists peco; then
        print_status "Installing peco..."
        # Download and install peco
        local version="0.5.11"
        local arch=$(uname -m)
        local platform="linux"
        
        if [ "$arch" = "x86_64" ]; then
            arch="amd64"
        elif [ "$arch" = "aarch64" ]; then
            arch="arm64"
        fi
        
        wget "https://github.com/peco/peco/releases/download/v${version}/peco-${platform}-${arch}-${version}.tar.gz" -O /tmp/peco.tar.gz
        tar -xzf /tmp/peco.tar.gz -C /tmp
        sudo mv /tmp/peco-${platform}-${arch}-${version}/peco /usr/local/bin/
        rm -rf /tmp/peco.tar.gz /tmp/peco-${platform}-${arch}-${version}
        print_success "peco installed successfully"
    else
        print_success "peco is already installed"
    fi
}

# Function to install ripgrep if not installed
install_ripgrep() {
    if ! command_exists rg; then
        print_status "Installing ripgrep..."
        sudo apt-get update
        sudo apt-get install -y ripgrep
        print_success "ripgrep installed successfully"
    else
        print_success "ripgrep is already installed"
    fi
}

# Function to install ag (the silver searcher) if not installed
install_ag() {
    if ! command_exists ag; then
        print_status "Installing ag (the silver searcher)..."
        sudo apt-get update
        sudo apt-get install -y silversearcher-ag
        print_success "ag installed successfully"
    else
        print_success "ag is already installed"
    fi
}

# Function to check required tools
check_required_tools() {
    print_status "Checking required tools..."
    
    required_tools="zsh git"
    missing_tools=""
    
    for tool in $required_tools; do
        if ! command_exists "$tool"; then
            missing_tools="$missing_tools $tool"
            print_warning "$tool is not installed"
        else
            print_success "$tool is installed"
        fi
    done
    
    if [ -n "$missing_tools" ]; then
        print_status "Installing missing required tools..."
        for tool in $missing_tools; do
            ensure_package "$tool"
        done
    fi
}

# Function to setup zsh configuration
setup_zsh_config() {
    print_status "Setting up zsh configuration..."
    
    # Install autojump
    install_autojump
    
    # Install peco
    install_peco
    
    # Install ripgrep
    install_ripgrep
    
    # Install ag
    install_ag
    
    # Backup existing .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Existing .zshrc backed up to .zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Copy the custom .zshrc
    print_status "Installing custom .zshrc..."
    cp "$(pwd)/.zshrc" "$HOME/.zshrc"
    
    # Create necessary directories
    print_status "Creating necessary directories..."
    mkdir -p "$HOME/.zsh/functions/Completion"
    
    # Set zsh as default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_status "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        print_success "Zsh set as default shell. Please log out and log back in for changes to take effect."
    else
        print_success "Zsh is already the default shell"
    fi
    
    print_success "Zsh configuration setup completed successfully!"
    print_status "Please restart your terminal or run 'source ~/.zshrc' to apply the changes."
}

# Function to show help
show_help() {
    echo "Linux Initial Configuration Setup Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -c, --check    Check required tools only"
    echo ""
    echo "This script will:"
    echo "  - Check for required tools (zsh, git)"
    echo "  - Install Oh My Zsh"
    echo "  - Install Powerlevel10k theme"
    echo "  - Install autojump"
    echo "  - Install peco"
    echo "  - Install ripgrep"
    echo "  - Install ag (the silver searcher)"
    echo "  - Set up custom .zshrc configuration"
    echo "  - Set zsh as default shell"
    echo ""
}

# Main function
main() {
    check_only=false
    
    # Parse command line arguments
    while [ $# -gt 0 ]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -c|--check)
                check_only=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Check if Ubuntu/Debian
    if [ ! -f /etc/ubuntu-release ] && [ ! -f /etc/debian_version ]; then
        print_warning "This script is designed for Ubuntu/Debian systems. Some features may not work."
    fi
    
    print_status "Starting Linux Initial Configuration Setup..."
    print_status "This script will check for required tools and set up zsh configuration."
    
    # Update package lists
    print_status "Updating package lists..."
    sudo apt-get update
    
    if [ "$check_only" = true ]; then
        check_required_tools
    else
        check_required_tools
        setup_zsh_config
        print_success "Linux Initial Configuration Setup completed successfully!"
        print_status "Please restart your terminal or run 'source ~/.zshrc' to apply the changes."
    fi
}

# Run main function
main "$@"
