



#!/bin/bash

# Example usage script to demonstrate the configured environment
# This script shows some of the features that will be available after setup

echo "=== Linux Initial Configuration - Example Usage ==="
echo ""

# Check if zsh is installed
if command_exists() {
    echo "✓ Zsh is installed: $(zsh --version)"
} else
    echo "✗ Zsh is not installed"
fi

# Check if peco is installed
if command_exists peco; then
    echo "✓ Peco is installed: $(peco --version)"
else
    echo "✗ Peco is not installed"
fi

# Check if autojump is installed
if command_exists j; then
    echo "✓ Autojump is installed"
else
    echo "✗ Autojump is not installed"
fi

# Check if Oh My Zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✓ Oh My Zsh is installed"
    echo "  Theme: $(grep ZSH_THEME ~/.oh-my-zsh/.zshrc | cut -d'=' -f2)"
    echo "  Plugins: $(grep plugins ~/.oh-my-zsh/.zshrc | cut -d'(' -f2 | cut -d')' -f1)"
else
    echo "✗ Oh My Zsh is not installed"
fi

# Show some example aliases that will be available
echo ""
echo "=== Example Aliases Available ==="
echo "  ll     - List files in long format"
echo "  la     - List all files including hidden"
echo "  ..     - Go up one directory"
echo "  ...    - Go up two directories"
echo "  grep   - Enhanced grep with color"
echo "  df     - Disk usage with human readable format"
echo "  du     - Directory usage with human readable format"

# Show some example functions that will be available
echo ""
echo "=== Example Functions Available ==="
echo "  iapt <search>    - Search and install packages using peco"
echo "  peco-select-history - Search command history with Ctrl+R"
echo "  peco-cdr         - Change directory from history with Ctrl+U"
echo "  peco-kill        - Kill processes with Ctrl+K"
echo "  peco-select-directory - Select directory with Ctrl+T"
echo "  peco-src         - Navigate to project directory with Ctrl+]"
echo "  pe <search>      - Search files with ripgrep and open in less"

# Show some example key bindings
echo ""
echo "=== Example Key Bindings ==="
echo "  Ctrl+R    - Search command history"
echo "  Ctrl+U    - Select directory from history"
echo "  Ctrl+T    - Select directory from current location"
echo "  Ctrl+K    - Kill processes"
echo "  Ctrl+]    - Navigate to project directory"
echo "  Ctrl+F    - Autojump directory selection"
echo "  Ctrl+X    - Expand magic abbreviations"
echo "  Space     - Expand magic abbreviations"

# Show some example abbreviations
echo ""
echo "=== Example Magic Abbreviations ==="
echo "  G    -> | grep"
echo "  X    -> | xargs"
echo "  T    -> | tail"
echo "  C    -> | cat"
echo "  W    -> | wc"
echo "  A    -> | awk"
echo "  S    -> | sed"
echo "  E    -> 2>&1 > /dev/null"
echo "  N    -> > /dev/null"

echo ""
echo "=== Setup Instructions ==="
echo "1. Run './install.sh' to install and configure everything"
echo "2. Restart your terminal or run 'source ~/.zshrc'"
echo "3. Run 'p10k configure' to customize your prompt"
echo "4. Add custom configurations to ~/.zshrc.mine"

echo ""
echo "=== Post Installation ==="
echo "After installation, you can:"
echo "- Use 'j <directory>' to jump to frequently visited directories"
echo "- Use 'iapt <search>' to search and install packages"
echo "- Use 'peco-select-history' to search through command history"
echo "- Use 'peco-kill' to manage processes"
echo "- Use 'peco-select-directory' to navigate directories"
echo "- Use 'pe <search>' to search files"

echo ""
echo "=== Configuration Files ==="
echo "The following files will be created/modified:"
echo "  ~/.zshrc          - Main zsh configuration"
echo "  ~/.zshrc.mine     - Custom user configurations"
echo "  ~/.p10k.zsh       - Powerlevel10k prompt configuration"
echo "  ~/.tmux.conf      - Tmux configuration"
echo "  ~/.vimrc          - Vim configuration"
echo "  ~/.ssh/config     - SSH configuration"

echo ""
echo "=== Backup ==="
echo "Your existing ~/.zshrc will be backed up to:"
echo "  ~/.zshrc.backup.YYYYMMDD_HHMMSS"

echo ""
echo "=== Troubleshooting ==="
echo "If you encounter issues:"
echo "1. Check that all packages are installed"
echo "2. Verify that all plugins are loaded"
echo "3. Check that the theme is properly installed"
echo "4. Run './setup.sh' again to re-install"
echo "5. Check the logs for any error messages"

echo ""
echo "=== Support ==="
echo "For issues or questions:"
echo "1. Check the README.md file"
echo "2. Review the setup.sh script"
echo "3. Create an issue in the repository"

echo ""
echo "=== Example Usage Complete ==="
echo "For more information, run 'man zsh' or visit the Oh My Zsh documentation:"
echo "  https://ohmyz.sh/"
echo "  https://github.com/romkatv/powerlevel10k"
echo "  https://github.com/peco/peco"
echo "  https://github.com/wting/autojump"




