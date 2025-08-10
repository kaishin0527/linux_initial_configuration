
#!/bin/bash

# Linux Initial Configuration Setup Script
# This script sets up a new Linux environment with zsh, peco, autojump, and custom configuration

set -e
set -u

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install package if not exists
install_package() {
    if ! command_exists "$1"; then
        print_status "Installing $1..."
        sudo apt-get update
        sudo apt-get install -y "$1"
        print_success "$1 installed successfully"
    else
        print_success "$1 is already installed"
    fi
}

# Main setup function
main() {
    print_status "Starting Linux Initial Configuration Setup..."
    
    # Check if running on Ubuntu/Debian-based system
    if ! command_exists apt-get; then
        print_error "This script is designed for Ubuntu/Debian-based systems"
        exit 1
    fi
    
    # Update package list
    print_status "Updating package list..."
    sudo apt-get update
    
    # Install essential packages
    print_status "Installing essential packages..."
    for package in zsh curl wget git build-essential autojump peco silversearcher-ag less vim tmux htop tree unzip tar gzip ripgrep; do
        install_package "$package"
    done
    
    # Install Oh My Zsh if not installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed successfully"
    else
        print_success "Oh My Zsh is already installed"
    fi
    
    # Install zsh plugins
    print_status "Installing zsh plugins..."
    
    # Install zsh-autosuggestions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # Install zsh-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
    
    # Install zsh-completions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
    fi
    
    # Install powerlevel10k theme
    if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
    
    # Create .zshrc if it doesn't exist
    if [ ! -f "$HOME/.zshrc" ]; then
        touch "$HOME/.zshrc"
    fi
    
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
    mkdir -p "$HOME/.local/share/marker"
    
    # Install marker if not installed
    if [ ! -f "$HOME/.local/share/marker/marker.sh" ]; then
        print_status "Installing marker..."
        bash <(curl -s https://raw.githubusercontent.com/pindexis/marker/master/install) -y
    fi
    
    # Install ghq if not installed
    if ! command_exists ghq; then
        print_status "Installing ghq..."
        go install github.com/x-motemen/ghq@latest
    fi
    
    # Set zsh as default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_status "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        print_success "Zsh set as default shell. Please log out and log back in for changes to take effect."
    else
        print_success "Zsh is already the default shell"
    fi
    
    print_success "Linux Initial Configuration Setup completed successfully!"
    print_status "Please restart your terminal or run 'source ~/.zshrc' to apply the changes."
}

# Run main function
main "$@"
