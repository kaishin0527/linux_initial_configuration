

# Linux Initial Configuration

This repository contains a setup script and configuration files to quickly set up a new Linux environment with zsh, peco, autojump, and other useful tools.

## Features

- **Zsh Configuration**: Comprehensive `.zshrc` with custom prompts, aliases, and functions
- **Powerful Plugins**: Includes zsh-autosuggestions, zsh-syntax-highlighting, and zsh-completions
- **Peco Integration**: Enhanced command history, directory selection, and process management
- **Autojump**: Smart directory navigation with `j` command
- **Modern Theme**: Powerlevel10k theme for beautiful terminal prompts
- **Essential Tools**: Installs commonly used development and system tools

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

### Manual Installation

If you prefer to install components manually:

1. Install essential packages:
```bash
sudo apt-get update
sudo apt-get install -y zsh curl wget git build-essential autojump peco silversearcher-ag less vim tmux htop tree unzip tar gzip ripgrep
```

2. Install Oh My Zsh:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

3. Install zsh plugins:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
```

4. Copy the `.zshrc` file:
```bash
cp .zshrc ~/.zshrc
```

5. Set zsh as default shell:
```bash
chsh -s $(which zsh)
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

### Zsh Plugins
- `zsh-autosuggestions` - Auto-suggestions for commands
- `zsh-syntax-highlighting` - Syntax highlighting
- `zsh-completions` - Additional completions
- `powerlevel10k` - Modern prompt theme

### Key Features
- **Command History Search**: `Ctrl+R` to search through history
- **Directory Navigation**: `Ctrl+U` to select directories from history
- **Autojump Integration**: `j` command for smart directory jumping
- **Process Management**: `Ctrl+K` to kill processes
- **Directory Selection**: `Ctrl+T` to select directories
- **Package Installation**: `iapt` command to search and install packages
- **File Management**: Smart file type associations

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

