

# Linux Initial Configuration

This repository contains a comprehensive setup script and configuration files to quickly set up a new Linux environment with zsh, peco, autojump, and other useful tools.

## Features

### Core Installation
- **Zsh Configuration**: Comprehensive `.zshrc` with custom prompts, aliases, and functions
- **Autojump**: Smart directory navigation with `j` command
- **Peco Integration**: Enhanced command history, directory selection, and process management
- **Essential Tools**: Installs commonly used development and system tools

### Advanced Features
- **Error Handling**: Robust error handling with detailed logging
- **Platform Detection**: Supports multiple Linux distributions
- **Configuration Backup**: Automatic backup of existing configurations
- **Setup Verification**: Post-installation verification of all tools
- **Configuration Export/Import**: Backup and restore your setup
- **Dry Run Mode**: Preview changes before applying them
- **Uninstall Mode**: Clean removal of all tools and restoration of original config
- **Testing Framework**: Built-in testing capabilities

## Prerequisites

- Ubuntu/Debian-based Linux distribution
- `sudo` privileges (required for package installation)
- Internet connection (for downloading packages and plugins)

## Installation

### Quick Setup

1. Clone this repository:
```bash
git clone https://github.com/your-username/linux_initial_configuration.git
cd linux_initial_configuration
```

2. Make the setup script executable:
```bash
chmod +x setup.sh
```

3. Run the setup script:
```bash
./setup.sh
```

### Advanced Usage

The setup script supports various options for different use cases:

```bash
# Check requirements only
./setup.sh --check

# Preview changes without applying them
./setup.sh --dry-run

# Uninstall all tools and restore original config
./setup.sh --uninstall

# Export current configuration
./setup.sh --export-config

# Import configuration from file
./setup.sh --import-config config.tar.gz

# Run tests
./setup.sh --test

# Verbose output
./setup.sh -v

# Show help
./setup.sh --help
```

## What Gets Installed

### System Packages
- `zsh` - Main shell
- `curl`, `wget` - Download utilities
- `git` - Version control
- `build-essential` - Compilation tools
- `autojump` - Smart directory navigation
- `peco` - Selection filter
- `silversearcher-ag` - Code search tool
- `less` - File viewer
- `vim` - Text editor
- `tmux` - Terminal multiplexer
- `htop` - Process viewer
- `tree` - Directory tree viewer
- `unzip`, `tar`, `gzip` - Archive tools
- `ripgrep` - Fast grep alternative

### Zsh Configuration
- Custom prompts for root and regular users
- Remote host detection in prompts
- Auto directory navigation and pushd settings
- Command history sharing and configuration
- Advanced completion system
- Magic abbreviations (G for grep, X for xargs, etc.)
- File extension associations (txt, html, rb, py, hs, php, c, cpp, java)

### Integration Features
- Peco integration for history, directory jumping, and process management
- Autojump integration for fast directory navigation
- Interactive package installation with `iapt` command
- Terminal title setting
- Smart file type associations

### Key Features
- **Command History Search**: `Ctrl+R` to search through history with peco
- **Directory Navigation**: `Ctrl+U` to select directories from history
- **Autojump Integration**: `Ctrl+F` to select directories with autojump
- **Process Management**: `Ctrl+K` to kill processes with peco
- **Directory Selection**: `Ctrl+T` to select directories with peco
- **Package Installation**: `iapt` command to search and install packages
- **File Management**: Smart file type associations
- **Code Search**: `pe` command to search code with ag and peco

## Customization

### Adding Custom Aliases
Add your custom aliases to `~/.zshrc.mine`:
```bash
echo 'alias mycommand="echo hello"' >> ~/.zshrc.mine
source ~/.zshrc
```

### Modifying the Theme
To customize the Powerlevel10k theme:
```bash
p10k configure
```

### Adding Plugins
Add plugins to the `plugins` array in `.zshrc`:
```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions my-custom-plugin)
```

## Troubleshooting

### Common Issues

1. **Permission Denied**: Make sure the setup script is executable:
   ```bash
   chmod +x setup.sh
   ```

2. **Plugin Not Found**: Ensure plugins are installed in the correct directory:
   ```bash
   ls -la ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
   ```

3. **Theme Not Loading**: Verify the Powerlevel10k theme is installed:
   ```bash
   ls -la ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k/
   ```

4. **Autojump Not Working**: Restart your terminal or run:
   ```bash
   source /usr/share/autojump/autojump.sh
   ```

### Resetting Configuration
If you need to reset to default configuration:
```bash
cp ~/.zshrc ~/.zshrc.backup
rm ~/.zshrc
# Run setup script again or manually recreate .zshrc
```

## Backup

The setup script automatically backs up your existing `.zshrc` file to:
```
~/.zshrc.backup.YYYYMMDD_HHMMSS
```

## Contributing

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Test the setup script
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

If you encounter any issues or have questions, please create an issue in the repository.

---

**Note**: After running the setup script, you may need to log out and log back in for all changes to take effect, or run `source ~/.zshrc` to apply the changes immediately.

