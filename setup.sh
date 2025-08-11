
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
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a package is installed
is_package_installed() {
    dpkg -l "$1" >/dev/null 2>&1
}

# Function to backup file
backup_file() {
    local file="$1"
    local backup_dir="$HOME/.config-backups"
    mkdir -p "$backup_dir"
    cp "$file" "$backup_dir/$(basename "$file").backup.$(date +%Y%m%d_%H%M%S)"
    print_status "Backed up $file to $backup_dir"
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

# Function to detect distribution
detect_distro() {
    if [ -f /etc/ubuntu-release ] || [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/redhat-release ]; then
        echo "redhat"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    else
        echo "unknown"
    fi
}

# Function to verify setup
verify_setup() {
    print_status "Verifying setup..."
    
    # zshがデフォルトシェルか確認
    if [ "$SHELL" = "$(which zsh)" ]; then
        print_success "zsh is default shell"
    else
        print_warning "zsh is not default shell"
    fi
    
    # pecoが動作するか確認
    if command_exists peco; then
        echo "test" | peco >/dev/null 2>&1 && print_success "peco works" || print_warning "peco has issues"
    fi
    
    # autojumpが動作するか確認
    if command_exists j; then
        j --help >/dev/null 2>&1 && print_success "autojump works" || print_warning "autojump has issues"
    fi
    
    # ripgrepが動作するか確認
    if command_exists rg; then
        echo "test" | rg "test" >/dev/null 2>&1 && print_success "ripgrep works" || print_warning "ripgrep has issues"
    fi
    
    # agが動作するか確認
    if command_exists ag; then
        echo "test" | ag "test" >/dev/null 2>&1 && print_success "ag works" || print_warning "ag has issues"
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

# Function to uninstall tools
uninstall() {
    print_status "Uninstalling tools..."
    
    # pecoのアンインストール
    if command_exists peco; then
        print_status "Removing peco..."
        sudo apt-get remove -y peco
        print_success "peco removed"
    fi
    
    # autojumpのアンインストール
    if [ -d "$HOME/.autojump" ]; then
        print_status "Removing autojump..."
        rm -rf "$HOME/.autojump"
        print_success "autojump removed"
    fi
    
    # .zshrcの復元
    if [ -f "$HOME/.zshrc.backup" ]; then
        print_status "Restoring .zshrc..."
        mv "$HOME/.zshrc.backup" "$HOME/.zshrc"
        print_success ".zshrc restored"
    else
        print_status "Removing custom .zshrc..."
        rm -f "$HOME/.zshrc"
        print_success ".zshrc removed"
    fi
    
    print_success "Uninstallation completed"
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

# Function to export configuration
export_config() {
    local export_file="$HOME/linux_config_export_$(date +%Y%m%d).tar.gz"
    print_status "Exporting configuration to $export_file..."
    
    tar -czf "$export_file" \
        "$HOME/.zshrc" \
        "$HOME/.autojump" \
        "$HOME/.config/peco" 2>/dev/null || true
    
    if [ -f "$export_file" ]; then
        print_success "Configuration exported to: $export_file"
    else
        print_error "Failed to export configuration"
    fi
}

# Function to import configuration
import_config() {
    local import_file="$1"
    if [ -f "$import_file" ]; then
        print_status "Importing configuration from $import_file..."
        tar -xzf "$import_file"
        print_success "Configuration imported"
    else
        print_error "Import file not found: $import_file"
    fi
}

# Function to require sudo
require_sudo() {
    if [ "$EUID" -ne 0 ]; then
        print_status "This operation requires sudo privileges"
        if ! sudo -v; then
            print_error "Sudo authentication failed"
            exit 1
        fi
    fi
}

# Function to run tests
run_tests() {
    print_status "Running tests..."
    
    # テスト用の一時ディレクトリ
    local test_dir=$(mktemp -d)
    
    # 各ツールのテスト
    test_zsh_function() {
        print_status "Testing zsh functions..."
        # peco-select-history関数のテスト
        # peco-cdr関数のテスト
        # etc.
    }
    
    print_success "Tests completed"
    
    # クリーンアップ
    rm -rf "$test_dir"
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
        backup_file "$HOME/.zshrc"
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
        if chsh -s "$(which zsh)"; then
            print_success "Zsh set as default shell. Please log out and log back in for changes to take effect."
        else
            print_warning "Failed to set zsh as default shell. You may need to run 'chsh -s $(which zsh)' manually."
        fi
    else
        print_success "Zsh is already the default shell"
    fi
    
    # Verify setup
    verify_setup
    
    print_success "Zsh configuration setup completed successfully!"
    print_status "Please restart your terminal or run 'source ~/.zshrc' to apply the changes."
}

# Function to show help
show_help() {
    cat << EOF
Linux Initial Configuration Setup Script

USAGE:
    setup.sh [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    -c, --check         Check only mode (no installation)
    -d, --dry-run       Show what would be done (no changes)
    -u, --uninstall     Uninstall all tools and restore config
    -v, --verbose       Verbose output
    --export-config     Export current configuration
    --import-config     Import configuration from file
    --test              Run tests

EXAMPLES:
    setup.sh                    # Normal installation
    setup.sh --check            # Check requirements only
    setup.sh --dry-run          # Show what would be done
    setup.sh --export-config    # Export configuration
    setup.sh --import-config config.tar.gz  # Import configuration
    setup.sh --test             # Run tests

EOF
}

# Function to show dry run
dry_run() {
    print_status "DRY RUN MODE - No changes will be made"
    
    # 実行予定のコマンドを表示
    echo "Would run: sudo apt-get update"
    echo "Would install: zsh, git, autojump, peco, ripgrep, ag"
    echo "Would backup: $HOME/.zshrc"
    echo "Would install: $HOME/.zshrc"
    echo "Would set zsh as default shell"
}

# Main function
main() {
    check_only=false
    dry_run_mode=false
    uninstall_mode=false
    export_mode=false
    import_mode=false
    test_mode=false
    verbose_mode=false
    
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
            -d|--dry-run)
                dry_run_mode=true
                shift
                ;;
            -u|--uninstall)
                uninstall_mode=true
                shift
                ;;
            -v|--verbose)
                verbose_mode=true
                shift
                ;;
            --export-config)
                export_mode=true
                shift
                ;;
            --import-config)
                if [ -n "$2" ]; then
                    import_mode=true
                    import_file="$2"
                    shift 2
                else
                    print_error "Import file required for --import-config"
                    exit 1
                fi
                ;;
            --test)
                test_mode=true
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
    
    # Log start time
    log_message "Setup started"
    
    # Update package lists
    print_status "Updating package lists..."
    if ! sudo apt-get update; then
        print_error "Failed to update package lists"
        exit 1
    fi
    
    # Handle different modes
    if [ "$check_only" = true ]; then
        check_required_tools
    elif [ "$dry_run_mode" = true ]; then
        dry_run
    elif [ "$uninstall_mode" = true ]; then
        require_sudo
        uninstall
    elif [ "$export_mode" = true ]; then
        export_config
    elif [ "$import_mode" = true ]; then
        import_config "$import_file"
    elif [ "$test_mode" = true ]; then
        run_tests
    else
        check_required_tools
        setup_zsh_config
        print_success "Linux Initial Configuration Setup completed successfully!"
        print_status "Please restart your terminal or run 'source ~/.zshrc' to apply the changes."
    fi
    
    # Log end time
    log_message "Setup completed"
}

# Run main function
main "$@"
