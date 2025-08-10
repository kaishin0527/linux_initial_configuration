



# Makefile for Linux Initial Configuration
# This file provides convenient commands for managing the setup

.PHONY: help install setup post-install clean backup test

# Default target
help:
	@echo "Available targets:"
	@echo "  install      - Run the complete installation (setup + post-install)"
	@echo "  setup        - Run the main setup script"
	@echo "  post-install - Run the post-installation script"
	@echo "  clean        - Clean up temporary files and caches"
	@echo "  backup       - Create a backup of current configuration"
	@echo "  test         - Run the example usage script"
	@echo "  help         - Show this help message"

# Run complete installation
install:
	@echo "Starting complete installation..."
	./install.sh

# Run main setup
setup:
	@echo "Running main setup..."
	./setup.sh

# Run post-installation
post-install:
	@echo "Running post-installation..."
	./post-install.sh

# Clean up temporary files and caches
clean:
	@echo "Cleaning up temporary files and caches..."
	rm -rf *.log *.tmp
	@echo "Cleaning up zsh cache..."
	rm -rf ~/.zsh_cache/*
	@echo "Cleaning up vim swap files..."
	find ~ -name "*.swp" -delete 2>/dev/null || true
	@echo "Cleaning up temporary files..."
	find ~ -name "*.tmp" -delete 2>/dev/null || true
	@echo "Cleanup completed"

# Create backup of current configuration
backup:
	@echo "Creating backup of current configuration..."
	@mkdir -p ~/linux_config_backup
	@cp ~/.zshrc ~/linux_config_backup/.zshrc.$(date +%Y%m%d_%H%M%S) 2>/dev/null || echo "No .zshrc found to backup"
	@cp ~/.vimrc ~/linux_config_backup/.vimrc.$(date +%Y%m%d_%H%M%S) 2>/dev/null || echo "No .vimrc found to backup"
	@cp ~/.tmux.conf ~/linux_config_backup/.tmux.conf.$(date +%Y%m%d_%H%M%S) 2>/dev/null || echo "No .tmux.conf found to backup"
	@cp ~/.ssh/config ~/linux_config_backup/ssh_config.$(date +%Y%m%d_%H%M%S) 2>/dev/null || echo "No ssh config found to backup"
	@echo "Backup completed in ~/linux_config_backup/"

# Run example usage script
test:
	@echo "Running example usage script..."
	./example-usage.sh

# Check system requirements
check:
	@echo "Checking system requirements..."
	@echo "Checking if running on Ubuntu/Debian..."
	@if command -v apt-get >/dev/null 2>&1; then \
		echo "✓ Package manager (apt-get) available"; \
	else \
		echo "✗ Package manager (apt-get) not available"; \
	fi
	@echo "Checking if sudo is available..."
	@if command -v sudo >/dev/null 2>&1; then \
		echo "✓ sudo available"; \
	else \
		echo "✗ sudo not available"; \
	fi
	@echo "Checking internet connection..."
	@ping -c 1 google.com >/dev/null 2>&1 && echo "✓ Internet connection available" || echo "✗ Internet connection not available"
	@echo "System requirements check completed"

# List installed packages
list-packages:
	@echo "Listing installed packages..."
	@echo "System packages:"
	@dpkg -l | grep -E "(zsh|peco|autojump|git|curl|wget|vim|tmux|htop|tree|silversearcher-ag|ripgrep)" || echo "No packages found"
	@echo ""
	@echo "Oh My Zsh plugins:"
	@ls -la ~/.oh-my-zsh/custom/plugins/ 2>/dev/null || echo "No Oh My Zsh plugins found"
	@echo ""
	@echo "Oh My Zsh themes:"
	@ls -la ~/.oh-my-zsh/custom/themes/ 2>/dev/null || echo "No Oh My Zsh themes found"

# Update Oh My Zsh
update-oh-my-zsh:
	@echo "Updating Oh My Zsh..."
	@cd ~/.oh-my-zsh && git pull
	@echo "Oh My Zsh updated"

# Update plugins
update-plugins:
	@echo "Updating zsh plugins..."
	@cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull
	@cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
	@cd ~/.oh-my-zsh/custom/plugins/zsh-completions && git pull
	@echo "Plugins updated"

# Update theme
update-theme:
	@echo "Updating Powerlevel10k theme..."
	@cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git pull
	@echo "Theme updated"

# Update all
update: update-oh-my-zsh update-plugins update-theme
	@echo "All components updated"

# Show configuration status
status:
	@echo "Configuration status:"
	@echo "Zsh version: $(zsh --version 2>/dev/null || echo 'Not installed')"
	@echo "Default shell: $$SHELL"
	@echo "Oh My Zsh: $$(if [ -d ~/.oh-my-zsh ]; then echo 'Installed'; else echo 'Not installed'; fi)"
	@echo "Powerlevel10k: $$(if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then echo 'Installed'; else echo 'Not installed'; fi)"
	@echo "Peco: $$(if command -v peco >/dev/null 2>&1; then echo 'Installed'; else echo 'Not installed'; fi)"
	@echo "Autojump: $$(if command -v j >/dev/null 2>&1; then echo 'Installed'; else echo 'Not installed'; fi)"
	@echo "Marker: $$(if [ -f ~/.local/share/marker/marker.sh ]; then echo 'Installed'; else echo 'Not installed'; fi)"
	@echo "GHQ: $$(if command -v ghq >/dev/null 2>&1; then echo 'Installed'; else echo 'Not installed'; fi)"

# Reset configuration
reset:
	@echo "Resetting configuration..."
	@echo "This will remove all installed components. Are you sure? (y/N)"
	@read answer; if [ "$$answer" = "y" ]; then \
		echo "Removing Oh My Zsh..."; \
		rm -rf ~/.oh-my-zsh; \
		echo "Removing .zshrc..."; \
		rm -f ~/.zshrc; \
		echo "Removing .p10k.zsh..."; \
		rm -f ~/.p10k.zsh; \
		echo "Removing .zshrc.mine..."; \
		rm -f ~/.zshrc.mine; \
		echo "Removing marker..."; \
		rm -rf ~/.local/share/marker; \
		echo "Reset completed. Run 'make install' to reinstall."; \
	else \
		echo "Reset cancelled."; \
	fi

# Create development environment
dev-env:
	@echo "Setting up development environment..."
	@mkdir -p ~/Projects ~/Development ~/Workspace
	@mkdir -p ~/.config/nvim ~/.config/tmux
	@echo "Development directories created"
	@echo "You can now clone repositories into ~/Projects or ~/Development"

# Initialize git repository
init-git:
	@echo "Initializing git repository..."
	@git init
	@git add .
	@git commit -m "Initial commit: Linux initial configuration setup"
	@echo "Git repository initialized"

# Create release
release:
	@echo "Creating release..."
	@mkdir -p releases
	@tar -czf releases/linux-initial-config-$(date +%Y%m%d).tar.gz \
		--exclude=.git \
		--exclude=*.log \
		--exclude=*.tmp \
		--exclude=releases \
		.
	@echo "Release created: releases/linux-initial-config-$(date +%Y%m%d).tar.gz"

# Show directory structure
tree:
	@echo "Directory structure:"
	@find . -type f -not -path "./.git/*" | sort

# Show file sizes
sizes:
	@echo "File sizes:"
	@du -sh * 2>/dev/null | sort -hr

# Check for updates
check-updates:
	@echo "Checking for updates..."
	@echo "Checking system packages..."
	@sudo apt update --quiet=2
	@sudo apt list --upgradable 2>/dev/null | grep -v "Listing..." || echo "No system updates available"
	@echo "Checking Oh My Zsh..."
	@cd ~/.oh-my-zsh && git fetch && git log --oneline --decorate --graph --all -n 5
	@echo "Checking plugins..."
	@cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git fetch && git log --oneline --decorate --graph --all -n 3
	@cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git fetch && git log --oneline --decorate --graph --all -n 3
	@cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git fetch && git log --oneline --decorate --graph --all -n 3
	@echo "Update check completed"




